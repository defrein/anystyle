# Spesifikasi Generasi Dataset Referensi Bibliografi oleh AI
## Format XML AnyStyle — Panduan untuk Model Bahasa

**Versi:** 2.0  
**Tujuan:** Panduan bagi AI dalam menghasilkan sequence referensi bibliografi sintetis yang realistis, konsisten, dan siap latih.

---

## 1. Tujuan dan Konteks

Dokumen ini adalah panduan operasional bagi model AI yang bertugas **menghasilkan** (bukan sekadar menganotasi) sequence referensi bibliografi dalam format XML AnyStyle. Sequence yang dihasilkan bersifat sintetis namun harus mencerminkan realitas bibliografi yang sesungguhnya — termasuk variasi kelengkapan field, variasi gaya penulisan, dan variasi jenis referensi.

Prinsip utama: **hasilkan apa yang realistis, bukan apa yang sempurna.**

---

## 2. Format Output

### 2.1 Struktur XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<dataset>
  <sequence>
    <author>...</author>
    <date>...</date>
    <title>...</title>
    <journal>...</journal>
    <volume>...</volume>
    <pages>...</pages>
  </sequence>
</dataset>
```

### 2.2 Aturan Format

1. XML harus well-formed dan UTF-8.
2. Setiap `<sequence>` mewakili tepat satu referensi.
3. Hanya gunakan tag dari daftar field resmi (Seksi 3). Jangan tambah tag custom.
4. Jangan buat tag kosong. Jika suatu field tidak relevan untuk referensi yang dihasilkan, hilangkan tag-nya sama sekali.
5. Tanda baca mengikuti konvensi bibliografi yang wajar untuk bahasa dan gaya yang sedang digunakan.
6. Gunakan escape XML untuk karakter khusus:
   - `&` → `&amp;`
   - `<` → `&lt;`
   - `>` → `&gt;`

---

## 3. Daftar Field Resmi

| Field | Deskripsi | Isi yang masuk | Isi yang tidak masuk |
|---|---|---|---|
| `author` | Penulis | Nama individu atau korporat yang tercantum sebagai pengarang | Editor, translator, publisher semata |
| `editor` | Editor | Nama editor dengan penanda peran (ed., Eds., red.) | Author biasa |
| `translator` | Penerjemah | Nama penerjemah dengan penanda peran | Editor |
| `director` | Sutradara | Nama sutradara karya audiovisual | Producer |
| `producer` | Produser | Nama produser karya audiovisual | Director |
| `title` | Judul karya | Judul utama beserta subjudul jika menyatu | Nama jurnal, nama prosiding, nama situs |
| `journal` | Nama jurnal | Nama jurnal atau serial periodik | Volume, issue, halaman |
| `container-title` | Judul kontainer | Buku induk, prosiding, seri, nama situs sebagai kontainer | Judul item utama |
| `volume` | Volume/nomor | Volume, issue, nomor laporan, nomor bagian | Halaman |
| `pages` | Halaman | Rentang halaman atau nomor artikel | Volume, issue |
| `date` | Tanggal publikasi | Tahun, bulan-tahun, atau tanggal lengkap | Edisi |
| `location` | Lokasi | Kota atau negara penerbitan | Nama penerbit |
| `publisher` | Penerbit | Nama penerbit, lembaga penerbit, atau organisasi pemilik dokumen | Lokasi |
| `edition` | Edisi | Edisi ke-n, revisi, cetakan ulang | Volume |
| `genre` | Genre/tipe | Thesis, dissertation, report, working paper, preprint, white paper, film, dsb. | Catatan akses |
| `medium` | Medium | Print, online, DVD, CD-ROM, dsb. | URL |
| `note` | Catatan | Tanggal akses, status publikasi (in press, accepted), keterangan tambahan | DOI atau URL murni |
| `source` | Sumber | Nama basis data, repository, atau indeks | Penerbit formal |
| `isbn` | ISBN | ISBN-10 atau ISBN-13 | DOI |
| `doi` | DOI | Identifier DOI | URL biasa |
| `url` | URL | URL atau URI lengkap | DOI murni |
| `citation-number` | Nomor sitasi | [12], 12., (12), angka superscript | Tahun |

---

## 4. Aturan Kelengkapan Field

### 4.1 Prinsip Dasar

AI **tidak wajib mengisi semua field** untuk setiap sequence. Kelengkapan field harus mencerminkan apa yang realistis ada pada jenis referensi yang bersangkutan. Referensi dengan field minim adalah kondisi normal dan valid, bukan error.

Field `title` adalah satu-satunya yang **selalu dihasilkan** karena hampir tidak ada referensi yang benar-benar tidak memiliki judul.

### 4.2 Panduan Kelengkapan per Jenis Referensi

| Jenis Referensi | Field yang umumnya ada | Field yang sering tidak ada |
|---|---|---|
| Artikel jurnal | `author`, `date`, `title`, `journal`, `volume`, `pages` | `publisher`, `location`, `isbn` |
| Buku | `author`, `date`, `title`, `publisher`, `location` | `journal`, `pages`, `url` |
| Bab buku | `author`, `date`, `title`, `editor`, `container-title`, `pages`, `publisher` | `journal`, `isbn` |
| Thesis/dissertation | `author`, `date`, `title`, `genre`, `publisher` | `journal`, `pages`, `url` |
| Laporan/report | `author`/`publisher`, `date`, `title`, `volume`, `publisher`, `location` | `journal`, `isbn` |
| Working paper | `author`, `date`, `title`, `volume`, `publisher` | `location`, `isbn` |
| Web resource | `title`, `url` | `author`, `date`, `publisher`, `pages` — semua opsional |
| Preprint | `author`, `date`, `title`, `source`, `doi` | `journal`, `publisher`, `pages` |
| Audiovisual | `director`/`producer`, `date`, `title`, `genre`, `publisher` | `journal`, `pages` |

### 4.3 Field yang Boleh Absen Tanpa Penjelasan

Field berikut boleh tidak dihasilkan untuk alasan yang realistis:

- **`author`** — web resource tanpa authorship eksplisit, dokumen anonim, dokumen institusional yang hanya mencantumkan penerbit
- **`date`** — halaman web tanpa tanggal, dokumen undated
- **`publisher`** — artikel jurnal, beberapa preprint
- **`location`** — publikasi digital, banyak working paper modern
- **`volume`/`pages`** — buku, web resource, thesis
- **`note`** — hanya hadir jika ada informasi akses atau status yang relevan
- **`isbn`/`doi`/`url`** — tergantung ketersediaan identifier

---

## 5. Panduan Variasi yang Wajib Dihasilkan

Agar dataset representatif, AI harus memvariasikan hal-hal berikut secara aktif:

### 5.1 Variasi Struktur Field

- Sequence dengan banyak field (artikel jurnal lengkap dengan DOI)
- Sequence dengan field minimal (web resource hanya `title` + `url`)
- Sequence tanpa `author` (dokumen institusional atau anonim)
- Sequence tanpa `date`
- Sequence dengan `author` ganda (dua, tiga, atau lebih penulis)
- Sequence dengan `editor` sebagai pengganti `author`

### 5.2 Variasi Format Tanggal

Gunakan format tanggal yang beragam sesuai konvensi bibliografi nyata:

```
2022.
(2022).
2022, 15 mars.
March 2022.
2022-03-15.
n.d.
u.å.          ← utan år (Swedish/Danish untuk undated)
```

### 5.3 Variasi Nama Penulis

```
Andersson, L.
Lindgren, M., & Persson, K.
Svensson, A., Eriksson, B., & Holm, C.
Myndigheten för digital förvaltning.
WHO.
van der Berg, J.
O'Brien, S.
```

### 5.4 Variasi URL

- URL pendek: `https://www.sst.dk/rapport`
- URL sedang: `https://www.naturvardsverket.se/klimat/klimatpolitik/ramverk/`
- URL panjang dengan path dalam dan parameter: `https://www.regeringen.se/contentassets/ab12cd34ef56/strategi-cirkular-ekonomi-2022.pdf`
- URL dengan file PDF: berakhiran `.pdf`
- URL dengan query string: `https://example.org/search?id=1234&lang=sv`

### 5.5 Variasi Nomor Laporan/Volume

```
2022:8.
Rapport 2022:14.
RiR 2021:15.
Working Paper No. 1432.
ER 2021:9.
VR 2022:04.
PM 2023:07.
Discussion Paper 45/2022.
Staff Memo 2023:1.
```

### 5.6 Variasi Tanda Baca dan Gaya Sitasi

Referensi nyata tidak menggunakan satu gaya seragam. AI harus memvariasikan:

```
<!-- Gaya APA-like -->
Lindström, E. (2022). Titel på verket. Förlag.

<!-- Gaya Vancouver-like -->
1. Lindström E. Titel på verket. Stad: Förlag; 2022.

<!-- Gaya Chicago-like -->
Lindström, Erik. Titel på verket. Stad: Förlag, 2022.

<!-- Gaya minimal tanpa tanda baca berlebih -->
Lindström E 2022 Titel på verket Förlag
```

---

## 6. Aturan Realisme Konten

### 6.1 Nama dan Institusi

- Gunakan nama orang yang realistis untuk bahasa target (nama Skandinavia untuk Swedish/Danish/Norwegian, dst.)
- Gunakan nama institusi yang nyata dan relevan secara geografis
- Nama jurnal, penerbit, dan lembaga harus terdengar plausibel

### 6.2 Tanggal

- Rentang tahun yang wajar: umumnya 1990–tahun berjalan
- Untuk web resource, tanggal akses harus lebih baru dari tanggal publikasi

### 6.3 Judul

- Judul harus relevan secara tematis dengan institusi atau penulis yang dicantumkan
- Judul dalam bahasa yang konsisten dengan bahasa referensi
- Subjudul diperbolehkan dan realistis: `Titel: En analys av något`

### 6.4 URL

- URL harus menggunakan domain yang konsisten dengan institusi penerbit
- Jangan menggunakan `example.com` kecuali untuk keperluan ilustrasi eksplisit
- Struktur path URL harus terlihat wajar (hindari path acak seperti `/abc/xyz/123456`)

### 6.5 Nomor Laporan dan DOI

- Format nomor laporan harus konsisten dengan konvensi lembaga yang digunakan
- DOI harus mengikuti pola: `10.XXXX/sesuatu` — jangan hasilkan DOI yang jelas tidak valid

---

## 7. Aturan per Jenis Referensi

### 7.1 Web Resource

- `title` selalu ada
- `url` selalu ada
- `author` diisi hanya jika ada individu atau lembaga yang secara eksplisit tercantum sebagai pengarang pada sumber
- Jika tidak ada author, gunakan `publisher` untuk nama lembaga pemilik/penerbit konten
- Jika tidak ada author maupun publisher yang jelas, cukup `title` + `url` + opsional `date` + `note`
- `note` berisi tanggal akses jika relevan; format disesuaikan bahasa (Swedia: *Hämtad*, Denmark: *Hentet*, Inggris: *Accessed*, Norwegia: *Hentet*)

```xml
<!-- Contoh: ada author individu -->
<sequence>
  <author>Lindgren, M.</author>
  <date>2022.</date>
  <title>Öppna data och offentlig förvaltning.</title>
  <publisher>Internetstiftelsen.</publisher>
  <url>https://internetstiftelsen.se/rapport-oppna-data-2022</url>
  <note>Hämtad 2023-04-10.</note>
</sequence>

<!-- Contoh: lembaga sebagai corporate author eksplisit -->
<sequence>
  <author>Naturvårdsverket.</author>
  <date>2023.</date>
  <title>Klimatpolitiskt ramverk – uppföljning 2023.</title>
  <url>https://www.naturvardsverket.se/klimat/uppfoljning-2023/</url>
  <note>Hämtad 2024-01-15.</note>
</sequence>

<!-- Contoh: tidak ada author, lembaga sebagai publisher -->
<sequence>
  <date>2023.</date>
  <title>Nationell lägesbild – organiserad brottslighet 2023.</title>
  <publisher>Polismyndigheten.</publisher>
  <url>https://polisen.se/om-polisen/publikationer/nationell-lagebild/</url>
  <note>Hämtad 2024-01-15.</note>
</sequence>

<!-- Contoh: tidak ada author, tidak ada date -->
<sequence>
  <title>Vägledning om tillgänglighet på webben.</title>
  <publisher>Myndigheten för digital förvaltning.</publisher>
  <url>https://www.digg.se/kunskap-och-stod/tillganglighet/vagledning</url>
  <note>Hämtad 2024-02-01.</note>
</sequence>
```

### 7.2 Thesis / Dissertation

- `author` hampir selalu ada
- `genre` wajib untuk membedakan jenis (Doktorsavhandling, Licentiatavhandling, PhD thesis, Masteruppsats, dsb.)
- `publisher` berisi nama universitas/institusi
- `url` dan `doi` opsional

```xml
<sequence>
  <author>Karlsson, S.</author>
  <date>2023.</date>
  <title>Algoritmer och rättssäkerhet – automatiserat beslutsfattande i svensk förvaltning.</title>
  <genre>Doktorsavhandling</genre>
  <publisher>Lunds universitet.</publisher>
</sequence>
```

### 7.3 Laporan / Report / Working Paper

- `volume` berisi nomor laporan
- `publisher` berisi nama lembaga penerbit laporan
- `author` bisa individu atau lembaga; boleh absen jika laporan anonim institusional
- `location` opsional

```xml
<sequence>
  <author>Konjunkturinstitutet.</author>
  <date>2023.</date>
  <title>Lönebildningsrapporten 2023.</title>
  <volume>Working Paper nr 153.</volume>
  <publisher>Konjunkturinstitutet.</publisher>
</sequence>
```

### 7.4 Artikel Jurnal

- `author`, `date`, `title`, `journal`, `volume`, `pages` adalah kombinasi ideal
- `doi` sangat dianjurkan untuk artikel modern
- `publisher` dan `location` biasanya tidak diisi

```xml
<sequence>
  <author>Smith, J., &amp; Müller, A.</author>
  <date>(2020).</date>
  <title>Language-aware citation parsing.</title>
  <journal>Journal of Bibliographic Data</journal>
  <volume>12(3),</volume>
  <pages>101-119.</pages>
  <doi>10.1234/jbd.2020.001</doi>
</sequence>
```

### 7.5 Buku

- `edition` diisi hanya jika bukan edisi pertama
- `isbn` dianjurkan
- `location` dan `publisher` umumnya keduanya ada

```xml
<sequence>
  <author>Andersen, L.</author>
  <date>2018.</date>
  <title>Metoder i informationsvidenskab.</title>
  <edition>2nd ed.</edition>
  <location>København:</location>
  <publisher>Nordic Academic Press.</publisher>
  <isbn>9781234567890</isbn>
</sequence>
```

---

## 8. Aturan Konsistensi Bahasa

1. Seluruh isi sequence harus konsisten dalam satu bahasa kecuali ada alasan bibliografis (misalnya judul asli berbeda bahasa).
2. Tanggal akses pada `<note>` mengikuti konvensi bahasa referensi:
   - Swedish: `Hämtad YYYY-MM-DD.`
   - Danish/Norwegian: `Hentet YYYY-MM-DD.`
   - English: `Accessed YYYY-MM-DD.`
   - German: `Abgerufen am TT.MM.JJJJ.`
3. Nama genre pada `<genre>` mengikuti bahasa referensi:
   - Swedish: `Doktorsavhandling`, `Licentiatavhandling`, `Rapport`
   - English: `Doctoral dissertation`, `Master's thesis`, `Technical report`
   - Danish: `Ph.d.-afhandling`, `Rapport`
4. Diakritik dan karakter khusus harus dipertahankan apa adanya (ä, ö, å, æ, ø, é, dll.).

---

## 9. Hal yang Tidak Boleh Dilakukan

1. **Jangan membuat tag kosong.** `<author/>` atau `<date></date>` tidak valid.
2. **Jangan memasukkan informasi yang tidak konsisten** — misalnya URL domain berbeda dengan publisher yang dicantumkan.
3. **Jangan meletakkan nama lembaga di `<author>` jika perannya hanya sebagai penerbit** — gunakan `<publisher>`.
4. **Jangan mencampur field** — nama jurnal tidak boleh masuk `<title>`, judul kontainer tidak boleh bercampur dengan judul item.
5. **Jangan menggunakan DOI palsu yang jelas tidak valid** — pola harus `10.XXXX/...`.
6. **Jangan memecah satu referensi menjadi lebih dari satu `<sequence>`.**
7. **Jangan menambah tag di luar daftar field resmi.**
8. **Jangan menormalkan atau menerjemahkan isi referensi** — pertahankan bahasa dan ejaan asli.

---

## 10. Checklist Sebelum Output

Sebelum menghasilkan batch sequence, AI harus memastikan:

- [ ] Setiap sequence punya minimal `<title>`
- [ ] Tidak ada tag kosong
- [ ] Variasi jenis referensi sesuai komposisi yang diminta
- [ ] Variasi kelengkapan field — ada yang lengkap, ada yang minim
- [ ] Nama, institusi, dan URL konsisten satu sama lain
- [ ] Bahasa konsisten dalam setiap sequence
- [ ] Tanda baca XML di-escape dengan benar (`&amp;` untuk `&`)
- [ ] XML well-formed keseluruhan

---

## 11. Contoh Batch Pendek (Campuran)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<dataset>

  <!-- Artikel jurnal lengkap -->
  <sequence>
    <author>Lindström, E., &amp; Holm, A.</author>
    <date>(2021).</date>
    <title>Digital transformation in Nordic public administration.</title>
    <journal>Scandinavian Journal of Public Policy</journal>
    <volume>14(2),</volume>
    <pages>88-112.</pages>
    <doi>10.1080/sjpp.2021.0088</doi>
  </sequence>

  <!-- Web resource tanpa author -->
  <sequence>
    <date>2023.</date>
    <title>Nationell plan för transportsystemet 2022–2033.</title>
    <publisher>Trafikverket.</publisher>
    <url>https://www.trafikverket.se/contentassets/nationell-plan-2022-2033.pdf</url>
    <note>Hämtad 2023-10-30.</note>
  </sequence>

  <!-- Web resource tanpa author dan tanpa date -->
  <sequence>
    <title>Vägledning om tillgänglighet på webben.</title>
    <publisher>Myndigheten för digital förvaltning.</publisher>
    <url>https://www.digg.se/kunskap-och-stod/tillganglighet/vagledning</url>
    <note>Hämtad 2024-02-01.</note>
  </sequence>

  <!-- Thesis -->
  <sequence>
    <author>Söderström, M.</author>
    <date>2023.</date>
    <title>Politisk polarisering i Sverige och Europa – en komparativ studie.</title>
    <genre>Doktorsavhandling</genre>
    <publisher>Uppsala universitet.</publisher>
  </sequence>

  <!-- Working paper dengan nomor laporan -->
  <sequence>
    <author>Henrekson, M., &amp; Stenkula, M.</author>
    <date>2022.</date>
    <title>Skatteincitament och riskkapitaltillgång för startup-bolag.</title>
    <volume>IFN Working Paper No. 1432.</volume>
    <publisher>Institutet för Näringslivsforskning.</publisher>
    <location>Stockholm.</location>
  </sequence>

  <!-- Buku dengan edisi -->
  <sequence>
    <author>Bergström, C., &amp; Boréus, K.</author>
    <date>2018.</date>
    <title>Textens mening och makt: metodbok i samhällsvetenskaplig text- och diskursanalys.</title>
    <edition>4. uppl.</edition>
    <location>Lund:</location>
    <publisher>Studentlitteratur.</publisher>
    <isbn>9789144126609</isbn>
  </sequence>

  <!-- Web resource minimal — hanya title dan url -->
  <sequence>
    <title>Om cookies och personuppgifter.</title>
    <url>https://www.imy.se/privatperson/dataskydd/cookies/</url>
  </sequence>

</dataset>
```