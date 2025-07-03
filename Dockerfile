# 1. Define a imagem base
# Usamos uma imagem oficial do Python com Alpine Linux para manter o tamanho final pequeno.
# A versão do Python é compatível com o que o projeto pede (3.10+).
FROM python:3.13.5-alpine3.22

# 2. Definir o diretório de trabalho dentro do contêiner
# Isso garante que os comandos subsequentes sejam executados neste diretório.
WORKDIR /app

# 3. Copiar o arquivo de dependências
# Copiamos o requirements.txt primeiro para aproveitar o cache de camadas do Docker.
# Se este arquivo não mudar, o Docker não reinstalará as dependências em builds futuros.
COPY requirements.txt .

# 4. Instalar as dependências
# Usamos --no-cache-dir para não armazenar o cache do pip, reduzindo o tamanho da imagem.
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiar o restante do código da aplicação
# Copia todos os arquivos do diretório atual (onde o Dockerfile está) para o WORKDIR (/app) no contêiner.
COPY . .

# 6. Expor a porta que a aplicação usa
# O Uvicorn, por padrão, roda na porta 8000.
EXPOSE 8000

# 7. Definir o comando para executar a aplicação
# Executa o servidor Uvicorn.
# --host 0.0.0.0 faz com que o servidor seja acessível de fora do contêiner.
# app:app refere-se ao objeto 'app' no arquivo 'app.py'.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
