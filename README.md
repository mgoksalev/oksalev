# oksalev

**Miguel** - @miguel246515

---

## 📱 Passo a passo antes de começar

### 1️⃣ Ativar opções do desenvolvedor

Vá em **Configurações → Sobre o telefone** e clique 7 vezes em **Número da compilação** até ativar o modo desenvolvedor.

![Ativar opção desenvolvedor](images/opcao.jpg)

### 2️⃣ Desativar restrições do processo secundário

Dentro de **Configurações → Opções do desenvolvedor**, ative a opção **"Restrições do processo secundário"**.

![Desativar restrições](images/ativar.jpg)

### 3️⃣ Baixar os apps necessários

- **Termux** (versão F-Droid, NÃO use a da Play Store):  
  👉 https://f-droid.org/repo/com.termux_118.apk

- **Termux:X11** (para exibir o desktop):  
  👉 https://release-assets.githubusercontent.com/github-production-release-asset/204363144/74371c29-4b41-499c-a67d-635f38690720?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-06-04T14%3A53%3A31Z&rscd=attachment%3B+filename%3Dapp-universal-debug.apk&rsct=application%2Fvnd.android.package-archive&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-06-04T13%3A53%3A03Z&ske=2026-06-04T14%3A53%3A31Z&sks=b&skv=2018-11-09&sig=9n0kUkwHrx2zPW5WxD%2BM96dBYdaV90KwWX5pt01Ix%2Fo%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc4MDU4MzkwNiwibmJmIjoxNzgwNTgyMTA2LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.mhMjE4Ur6g828He8E0Gl0lIc4TD672YcJ_oBfNrdOII&response-content-disposition=attachment%3B%20filename%3Dapp-universal-debug.apk&response-content-type=application%2Fvnd.android.package-archive

### 4️⃣ Instalar o git dentro do Termux

Abra o Termux e digite:

```bash
pkg install git
```

### 5️⃣ O que é isso?

Um script install.sh que transforma seu Termux em um desktop XFCE rodando em dispositivos ARM64 (a maioria dos celulares Android).

O que o script faz?

1. Atualiza o Termux
2. Instala o XFCE (ambiente desktop)
3. Configura o básico para rodar
4. Deixa tudo pronto pra usar

Como usar

```bash
git clone https://github.com/mgoksalev/oksalev
cd oksalev
chmod +x install.sh
./install.sh
```

Depois da instalação, inicie o desktop com:

```bash
cd && ./start.sh
```

### 6️⃣ Requisitos

· Android 8 ou superior

· Termux instalado (versão F-Droid)

· 2GB RAM de espaço livre
