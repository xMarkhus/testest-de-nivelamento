<template>
    <div class="w-full text-center mx-auto my-5 p-5">
        <h1 class="text-3xl text-left mb-4">🔍 Buscar operadora em relatório CADOP</h1>

        <div class="w-full flex gap-2.5 mb-4 items-center">
            <input v-model="query" @keyup.enter="buscar" placeholder="Digite sua busca..."
                class="flex-1 border-2 p-2.5 rounded-[5px] border-solid border-[#ccc]" />

            <button @click="buscar"
                class="bg-[#42b883] text-white font-bold cursor-pointer px-[15px] py-2.5 rounded-[5px] border-[none] hover:bg-[#369f6e]">
                Buscar
            </button>
        </div>


        <div v-if="resultados.length" class="w-full grid gap-4 sm:grid-cols-2 md:grid-cols-3">
            <div v-for="(item, index) in resultados" :key="index"
                class="flex flex-col w-full text-left gap-2.5 mb-2.5 p-[15px] rounded-[5px] border-2 border-solid border-[#ccc]">
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]">
                    <strong>Registro ANS:</strong> {{ item.Registro_ANS }}
                </p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]">
                    <strong>Data Registro ANS:</strong> {{ item.Data_Registro_ANS }}
                </p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]">
                    <strong>Razão Social:</strong> {{ item.Razao_Social }}
                </p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]"><strong>CNPJ:</strong> {{ item.CNPJ }}</p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]">
                    <strong>Representante:</strong> {{ item.Representante }}
                </p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]">
                    <strong>Cargo Representante:</strong> {{ item.Cargo_Representante }}
                </p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]"><strong>CEP:</strong> {{ item.CEP }}</p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]"><strong>UF:</strong> {{ item.UF }}</p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]"><strong>Cidade:</strong> {{ item.Cidade }}</p>
                <p class="text-black p-[5px] bg-[#42b883] rounded-[5px]">
                    <strong>Modalidade:</strong> {{ item.Modalidade }}
                </p>
            </div>
        </div>

        <p v-else-if="mensagem" class="text-red-600 mt-2.5 font-bold">{{ mensagem }}</p>
    </div>
</template>

<script setup>
import { ref } from "vue";

const query = ref("");
const resultados = ref([]);
const mensagem = ref("");

const buscar = async () => {
    if (!query.value.trim()) return;

    try {
        const response = await fetch(
            `http://localhost:8000/buscar?q=${query.value}`
        );
        const data = await response.json();

        if (data.mensagem) {
            resultados.value = [];
            mensagem.value = data.mensagem;
        } else {
            resultados.value = data.map((item) => ({
                Registro_ANS: item.Registro_ANS,
                Data_Registro_ANS: item.Data_Registro_ANS,
                Razao_Social: item.Razao_Social,
                CNPJ: item.CNPJ,
                Modalidade: item.Modalidade,
                CEP: item.CEP,
                UF: item.UF,
                Representante: item.Representante,
                Cidade: item.Cidade,
                Cargo_Representante: item.Cargo_Representante,
            }));
            mensagem.value = "";
        }
    } catch (error) {
        mensagem.value = "Erro ao buscar os dados.";
    }
};
</script>