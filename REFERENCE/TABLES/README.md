```mermaid
graph LR
   A[Start] --> B{Mermaid extension installed?}
   B -- Yes --> C[Diagram renders]
  B -- No --> D[Install/Enable Mermaid extension]
  D --> B
  C --> E[Done]
```
