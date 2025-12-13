# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# выбираем директорию для менеджера пакетов zinit и плагинов
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Устанавливаем Zinit, если его нет
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Устанавливаем тему Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

## Плагины
#
# расширение для подсказок
zinit light zsh-users/zsh-syntax-highlighting
# расширение для автодополнения
zinit light zsh-users/zsh-completions
# расширение для подсказок в строке
zinit light zsh-users/zsh-autosuggestions

# Автозагрузка раширений
autoload -U compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

