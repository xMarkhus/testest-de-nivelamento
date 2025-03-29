import os
import requests
from bs4 import BeautifulSoup
import zipfile


os.makedirs("outputs", exist_ok=True)

URL = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"

res = requests.get(URL)

soup = BeautifulSoup(res.text, "html.parser")


def is_valid_pdf(link: str) -> bool:
    href = link.lower()
    return href.endswith(".pdf") and ("anexo_i" in href or "anexo_ii" in href)


pdf_links = [
    link["href"]
    for link in soup.find_all("a", href=True)
    if is_valid_pdf(link["href"])
]

arquivos_baixados = []
for pdf_url in pdf_links:

    if "anexo_i_" in pdf_url.lower():
        nome_arquivo = "outputs/Anexo_I.pdf"
    elif "anexo_ii_" in pdf_url.lower():
        nome_arquivo = "outputs/Anexo_II.pdf"
    else:
        continue

    print(30 * '-')
    print(f"Baixando {pdf_url}...")
    print(30 * '-')

    pdf_res = requests.get(pdf_url)
    with open(nome_arquivo, "wb") as f:
        f.write(pdf_res.content)

    print(f"Salvo como {nome_arquivo}")
    print(30 * '-')

    arquivos_baixados.append(nome_arquivo)

zip_filename = "outputs/arquivos_comprimidos.zip"
with zipfile.ZipFile(zip_filename, "w", zipfile.ZIP_DEFLATED) as zip:
    for arquivo in arquivos_baixados:
        zip.write(arquivo, os.path.basename(arquivo))  # Salva no ZIP com o nome do arquivo original
        print(f"Adicionado ao ZIP: {arquivo}")
        print(30 * '-')

print(f"Arquivos compactados em {zip_filename}")
print(30 * '-')
