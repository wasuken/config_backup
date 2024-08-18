#!/bin/bash

# 引数でバックアップ先ディレクトリを指定
backup_dir="${1:-backup}"

# バックアップリストファイル
backup_list="backup_list.txt"

# バックアップ先ディレクトリがなければ作成
mkdir -p "$backup_dir"

# バックアップリストに従ってファイルをバックアップ
while IFS= read -r file; do
    # ワイルドカードを展開してファイルをコピー
    for matched_file in $file; do
        if [ -e "$matched_file" ]; then
            # フルパスを取得し、バックアップ先ディレクトリに保存
            full_path="$(realpath "$matched_file")"
            dest_dir="$backup_dir/$(dirname "$full_path")"
            mkdir -p "$dest_dir"
            cp --parents "$matched_file" "$backup_dir/"
        fi
    done
done < "$backup_list"

# tar.gzファイルを作成
tar czf "${backup_dir}.tar.gz" -C "$backup_dir" .

# 一時的なバックアップディレクトリを削除
rm -fr "$backup_dir"
