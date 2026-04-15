# Training Single Multilingual Model (AnyStyle)

## Tujuan

Menggabungkan dataset referensi dari 11 bahasa (5 tipe: book, chapter, conference, journal, web) menjadi 1 model universal.

## Langkah

1. Combine dataset

```bash
ruby scripts/train_multilang.rb combine
```

Output: `res/parser/multilang_combined.xml`

2. Train model

```bash
anystyle train res/parser/multilang_combined.xml res/models/multilang.mod
```

3. Validasi dan penggunaan

```bash
anystyle -P res/models/multilang.mod check res/parser/gold.xml
anystyle -P res/models/multilang.mod parse references.txt -f json
```