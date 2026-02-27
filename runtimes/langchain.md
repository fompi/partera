---
id: runtime.langchain
type: runtime
category: framework
name: "LangChain"
version: 1.0.0
description: "Framework para aplicaciones con LLMs y chains"
tags: [runtime, langchain, framework, chains]
supports_capabilities: [all]
supports_tool_calling: true
supports_system_prompt: true
underlying_models: [openai, anthropic, ollama, huggingface]
estimated_tokens: 235
---

# Runtime: LangChain

## Características
- Framework modular para pipelines LLM
- Soporte para múltiples backends (OpenAI, Anthropic, Ollama, HuggingFace)
- LangChain Expression Language (LCEL) para chains declarativos
- Integración nativa con vectorstores y retrieval

## Mapeo
- System prompt compuesto → `SystemMessage` o `ChatPromptTemplate`
- Roles del sistema → Chains o Agents individuales
- Chains del sistema → LangChain LCEL chains o `SequentialChain`

## Ejemplo de uso
```python
from langchain_anthropic import ChatAnthropic
from langchain.prompts import ChatPromptTemplate, SystemMessagePromptTemplate
from langchain.schema import HumanMessage

llm = ChatAnthropic(model="claude-sonnet-4-6")

prompt = ChatPromptTemplate.from_messages([
    SystemMessagePromptTemplate.from_template(composed_prompt),
    ("human", "{input}")
])

chain = prompt | llm
result = chain.invoke({"input": "Analiza este código: ..."})
```

## Uso con tools
```python
from langchain.tools import tool
from langchain.agents import create_tool_calling_agent, AgentExecutor

@tool
def web_search(query: str) -> str:
    """Search the web for information."""
    ...

agent = create_tool_calling_agent(llm, [web_search], prompt)
executor = AgentExecutor(agent=agent, tools=[web_search])
```

## Instalación
```bash
pip install langchain langchain-anthropic langchain-openai
```

## Notas
- Los prompts compuestos son compatibles directamente como `SystemMessage`
- LCEL permite componer pipelines de forma declarativa
- Soporta streaming, callbacks y observabilidad
