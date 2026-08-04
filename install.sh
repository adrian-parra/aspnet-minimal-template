#!/bin/bash

# ==============================================================================
# Script de Instalación Automática - ASP.NET Minimal API Starter Template
# ==============================================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${CYAN}${BOLD}"
echo "================================================================"
echo "  ⚙️ Instalando Plantilla ASP.NET Core Minimal API Starter      "
echo "================================================================"
echo -e "${NC}"

# 1. Instalar la plantilla nativa de dotnet
echo -e "📦 Instando la plantilla en el SDK de .NET..."
dotnet new install "$SCRIPT_DIR/template" --force

# 2. Configurar el comando CLI en ~/.bin/
BIN_DIR="$HOME/.bin"
mkdir -p "$BIN_DIR"

echo -e "🚀 Copiando el comando CLI 'create-aspnet-api' a $BIN_DIR..."
cp "$SCRIPT_DIR/bin/create-aspnet-api" "$BIN_DIR/create-aspnet-api"
chmod +x "$BIN_DIR/create-aspnet-api"

# 3. Agregar ~/.bin al PATH en ~/.zshrc o ~/.bashrc si no existe
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q 'export PATH="$HOME/.bin:$PATH"' "$SHELL_CONFIG"; then
        echo -e "🔧 Agregando ~/.bin al PATH en $SHELL_CONFIG..."
        echo '' >> "$SHELL_CONFIG"
        echo '# Antigravity CLI Tools' >> "$SHELL_CONFIG"
        echo 'export PATH="$HOME/.bin:$PATH"' >> "$SHELL_CONFIG"
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}✨ ¡Instalación completada con éxito!${NC}"
echo "----------------------------------------------------------------"
echo -e "Puedes usar la plantilla de 2 formas:"
echo ""
echo -e "1) ${BOLD}Nativo de .NET:${NC}"
echo -e "   ${CYAN}dotnet new minimal-api -n MiNuevaApi${NC}"
echo ""
echo -e "2) ${BOLD}Script CLI Interactivo:${NC}"
echo -e "   ${CYAN}create-aspnet-api MiNuevaApi${NC}"
echo "----------------------------------------------------------------"
