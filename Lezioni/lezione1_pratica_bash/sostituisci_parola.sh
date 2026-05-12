#!/usr/bin/env bash
# Mini script didattico: sostituisce una parola in un file di input e salva su output.

input_file="$1"
parola_vecchia="$2"
parola_nuova="$3"
output_file="$4"

if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <input_file> <parola_vecchia> <parola_nuova> <output_file>"
  exit 1
fi

sed "s/${parola_vecchia}/${parola_nuova}/g" "$input_file" > "$output_file"
echo "File creato: $output_file"
