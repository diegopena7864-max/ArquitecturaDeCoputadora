import tkinter as tk
from tkinter import filedialog, messagebox

# ==========================
# Mapa de OPCODES y FUNCTS
# ==========================

opcode_map = {
    # R-TYPE (opcode = 000000)
    'add': '000000',
    'sub': '000000',
    'and': '000000',
    'or':  '000000',
    'slt': '000000',

    # I-TYPE aritméticas / lógicas
    'addi': '001000',
    'andi': '001100',
    'ori':  '001101',
    'xori': '001110',
    'slti': '001010',

    # I-TYPE memoria
    'lw':   '100011',
    'sw':   '101011',

    # I-TYPE control de flujo
    'beq':  '000100',

    # J-TYPE
    'j':    '000010'
}

funct_map = {
    'add': '100000',
    'sub': '100010',
    'and': '100100',
    'or':  '100101',
    'slt': '101010'
}

# ==========================
# Utilidades
# ==========================

def to_binary(value, length=32):
    """
    Convierte un valor entero (puede ser negativo) a binario de 'length' bits
    usando complemento a 2.
    """
    val = int(value)
    if val < 0:
        val = (1 << length) + val
    return f"{val:0{length}b}"

def encode_r(opcode, parts):
    """
    Formato esperado:
        add rd rs rt
        sub rd rs rt
        and rd rs rt
        or  rd rs rt
        slt rd rs rt
    con registros NUMÉRICOS: $1, $2, $3, ...
    """
    if len(parts) != 4:
        raise ValueError(f"Formato R inválido: {' '.join(parts)}")

    mn = opcode
    if mn not in funct_map:
        raise ValueError(f"Función R-type no soportada: {mn}")

    rd = to_binary(parts[1].replace('$', ''), 5)
    rs = to_binary(parts[2].replace('$', ''), 5)
    rt = to_binary(parts[3].replace('$', ''), 5)
    shamt = "00000"
    funct = funct_map[mn]

    return opcode_map[mn] + rs + rt + rd + shamt + funct

def encode_i(opcode, parts):
    mn = opcode

    if mn in ("addi", "andi", "ori", "xori", "slti"):
        if len(parts) != 4:
            raise ValueError(f"Formato I inválido: {' '.join(parts)}")
        rt = to_binary(parts[1].replace('$', ''), 5)
        rs = to_binary(parts[2].replace('$', ''), 5)
        imm = to_binary(parts[3], 16)
        return opcode_map[mn] + rs + rt + imm

    if mn in ("lw", "sw"):
        if len(parts) != 4:
            raise ValueError(f"Formato {mn.upper()} inválido: {' '.join(parts)}")
        rt = to_binary(parts[1].replace('$', ''), 5)
        base = to_binary(parts[2].replace('$', ''), 5)
        offset = to_binary(parts[3], 16)
        return opcode_map[mn] + base + rt + offset

    if mn == "beq":
        # beq rs rt offset
        if len(parts) != 4:
            raise ValueError(f"Formato BEQ inválido: {' '.join(parts)}")
        rs = to_binary(parts[1].replace('$', ''), 5)
        rt = to_binary(parts[2].replace('$', ''), 5)
        offset = to_binary(parts[3], 16)
        return opcode_map[mn] + rs + rt + offset

    raise ValueError(f"Instrucción I-type no soportada: {mn}")

def encode_j(opcode, parts):
    """
    J-TYPE:
        j address

    address se espera como entero (índice de instrucción / palabra).
    """
    if len(parts) != 2:
        raise ValueError(f"Formato J inválido: {' '.join(parts)}")
    addr = to_binary(parts[1], 26)
    return opcode_map[opcode] + addr

def convert_instruction(line):
    """
    Convierte una línea de ensamblador a un string de 32 bits.
    Si la línea es vacía o comentario, regresa None.
    """
    # Quitar comentarios
    if '#' in line:
        line = line.split('#', 1)[0]
    line = line.strip()
    if not line:
        return None

    # Reemplazar comas por espacios
    line = line.replace(',', ' ')
    parts = line.split()
    if not parts:
        return None

    opcode = parts[0].lower()
    if opcode not in opcode_map:
        raise ValueError(f"Opcode no soportado: {opcode}")

    if opcode in funct_map:
        # R-TYPE
        return encode_r(opcode, parts)
    elif opcode in ("addi", "andi", "ori", "xori", "slti", "lw", "sw", "beq"):
        # I-TYPE
        return encode_i(opcode, parts)
    elif opcode == "j":
        # J-TYPE
        return encode_j(opcode, parts)
    else:
        raise ValueError(f"Instrucción no manejada: {opcode}")

# ==========================
# Lógica de GUI
# ==========================

def select_file(text_widget):
    file_path = filedialog.askopenfilename(
        title="Seleccionar archivo .asm",
        filetypes=[("Archivos de texto", "*.txt *.asm"), ("Todos", "*.*")]
    )
    if not file_path:
        return
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
        text_widget.delete("1.0", tk.END)
        text_widget.insert("1.0", content)
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo leer el archivo:\n{e}")

def decode_text(text_widget):
    content = text_widget.get("1.0", tk.END)
    lines = content.splitlines()

    decoded_bytes = []
    errors = []

    for idx, line in enumerate(lines, start=1):
        try:
            bin32 = convert_instruction(line)
            if bin32 is None:
                continue  # línea vacía / comentario
            # Partimos en 4 bytes de 8 bits (big-endian)
            b1 = bin32[0:8]
            b2 = bin32[8:16]
            b3 = bin32[16:24]
            b4 = bin32[24:32]
            decoded_bytes.extend([b1, b2, b3, b4])
        except ValueError as e:
            errors.append(f"// Error en linea {idx}: {e}")

    result = "// Instrucciones decodificadas para memoria Verilog ($readmemb)\n"
    if errors:
        result += "\n".join(errors) + "\n\n"

    result += "\n".join(decoded_bytes)

    text_widget.delete("1.0", tk.END)
    text_widget.insert("1.0", result)

def save_report(text_widget):
    content = text_widget.get("1.0", tk.END)
    if not content.strip():
        messagebox.showwarning("Atención", "No hay contenido para guardar.")
        return

    file_path = filedialog.asksaveasfilename(
        title="Guardar archivo .mem",
        defaultextension=".mem",
        filetypes=[("Archivos de memoria", "*.mem"), ("Texto", "*.txt"), ("Todos", "*.*")]
    )
    if not file_path:
        return

    try:
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content)
        messagebox.showinfo("Éxito", f"Archivo guardado en:\n{file_path}")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo guardar el archivo:\n{e}")

def create_gui():
    window = tk.Tk()
    window.title("Decodificador MIPS a Binario")
    window.geometry("800x600")

    tk.Label(window, text="Ensamblador MIPS Simplificado", font=("Arial", 18)).pack(pady=10)

    text_widget = tk.Text(window, height=20, width=80, font=("Consolas", 12))
    text_widget.pack(pady=10)

    tk.Button(window, text="Cargar Archivo", command=lambda: select_file(text_widget)).pack(pady=2)
    tk.Button(window, text="Decodificar a Binario", command=lambda: decode_text(text_widget)).pack(pady=2)
    tk.Button(window, text="Guardar (.mem)", command=lambda: save_report(text_widget)).pack(pady=2)

    window.mainloop()

if __name__ == "__main__":
    create_gui()
