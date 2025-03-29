import os
import pandas as pd
import tabula
import zipfile


output_dir = "outputs"

tabelas = tabula.read_pdf(
    os.path.join(output_dir, "Anexo_I.pdf"), pages="3-181", lattice=True, multiple_tables=True
)

df = pd.concat(tabelas, ignore_index=True)

df_filtrado = df[df.iloc[:, 0] != "PROCEDIMENTO"]

df_final = df_filtrado.rename(
    columns={"OD": "Seg. Odontológica", "AMB": "Seg. Ambulatorial"}
)

nome_arquivo = os.path.join(output_dir, "df_final.csv")
df_final.to_csv(nome_arquivo, index=False)

print(30 * "-")
print(f"Dataframe salvo como {nome_arquivo}")
print(30 * "-")

zip_filename = os.path.join(output_dir, "Teste_Marcos_Rogerio.zip")
with zipfile.ZipFile(zip_filename, "w", zipfile.ZIP_DEFLATED) as zip:
    zip.write(nome_arquivo, os.path.basename(nome_arquivo))

print(f"O {nome_arquivo} foi compactado em {zip_filename}")
print(30 * "-")
