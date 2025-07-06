# 📱 [Fantacalcio] – SwiftUI App

## 🧠 Scelte Architetturali

### ✅ SwiftUI
Utilizzo esclusivo di SwiftUI per costruire l'interfaccia in modo dichiarativo, sfruttando i binding e il data flow reattivo.

### ✅ MVVM (Model - View - ViewModel)
L'app è strutturata seguendo il pattern MVVM

### ✅ Networking
Comunicazione asincrona tramite `URLSession` e `async/await`. Il servizio di rete è isolato in una classe dedicata, facilmente mockabile per i test.

## 🔧 Dipendenze Esterne

Non ho utilizzato librerie esterne, in quanto, successivamente all'analisi dei requisiti, non sono risultate necessarie per il corretto funzionamento e la semplicità del progetto.

### 🗃️ InMemoryCache
Per ottimizzare le prestazioni e ridurre il numero di chiamate ripetute, ho implementato una cache in memoria personalizzata (`InMemoryCache`).

- Riduce il carico sul layer di rete
- Migliora la reattività dell'app
- Facile da estendere e testare

### 💾 Persistenza dei Dati: UserDefaults
Per la gestione dei dati dei **preferiti**, ho optato per **UserDefaults** perché:

- I dati da salvare sono **pochi e semplici** (solo gli ID degli elementi preferiti)
- L’uso di soluzioni più complesse come **CoreData** o **SwiftData** sarebbe stato un **overkill**, aumentando inutilmente la complessità del progetto

### ⚙️ Tab Bar Custom
Ho scelto di **non utilizzare `TabView`** nativa, ma di costruire una tab bar personalizzata per avere:

- Controllo completo su stile e comportamento
- Supporto per animazioni, badge e icone dinamiche
- Allineamento con un design su misura

