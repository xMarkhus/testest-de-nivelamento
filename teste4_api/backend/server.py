import re
import pandas as pd
import unidecode
from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
import os

app = FastAPI()


@app.get("/")
def root():
    return RedirectResponse("/docs")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

csv_file_path = os.path.join(os.path.dirname(__file__), "data", "Relatorio_cadop.csv")

try:
    df = pd.read_csv(csv_file_path, delimiter=";", encoding="utf-8", on_bad_lines="skip")
    print("✅ CSV carregado com sucesso!")
except Exception as e:
    print(f"❌ Erro ao carregar CSV: {e}")


@app.get("/buscar")
def buscar(q: str = Query(..., min_length=1)):
    try:
        q_normalizado = unidecode.unidecode(q)
        q_safe = re.escape(q_normalizado)

        resultados = df[
            df.apply(
                lambda row: row.astype(str)
                .apply(lambda x: unidecode.unidecode(x))
                .str.contains(q_safe, case=False, na=False)
                .any(),
                axis=1,
            )
        ]

        if resultados.empty:
            return {"mensagem": "Nenhum resultado encontrado."}

        return resultados.fillna("").to_dict(orient="records")

    except Exception as e:
        print(f"❌ Erro na busca: {e}")
        raise HTTPException(status_code=500, detail=f"Erro interno: {e}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
