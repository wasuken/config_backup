#!/bin/bash

# 引数で復元先ディレクトリを指定
restore_dir="${1:-.}"

# バックアップ元ディレクトリ（解凍後のディレクトリ）
backup_dir="backup"

# tar.gzファイルを解凍
tar xzf "${backup_dir}.tar.gz" -C "$restore_dir"

# バックアップリストに従ってファイルを復元
while IFS= read -r file; do
    if [ -e "$restore_dir/$backup_dir/$file" ]; then
        mkdir -p "$restore_dir/$(dirname "$file")"
        cp -r "$restore_dir/$backup_dir/$file" "$restore_dir/$(dirname "$file")"
    fi
done < "$backup_list"

# 一時的なバックアップディレクトリを削除
rm -fr "$restore_dir/$backup_dir"
