---
id: runtime.autogen
type: runtime
category: framework
name: "AutoGen"
version: 1.0.0
description: "Framework de Microsoft para agentes conversacionales"
tags: [runtime, autogen, microsoft, framework, conversational]
supports_capabilities: [all]
supports_tool_calling: true
supports_system_prompt: true
underlying_models: [openai, azure-openai]
estimated_tokens: 225
---

# Runtime: AutoGen

## Características
- Framework multi-agente de Microsoft basado en conversación
- Agents que se comunican entre sí vía mensajes
- Soporte para ejecución de código en sandbox
- Integración con Azure OpenAI y OpenAI

## Mapeo
- System prompt compuesto → `system_message` del AssistantAgent
- Roles del sistema → AssistantAgents individuales
- Chains → GroupChat con múltiples agentes

## Ejemplo de uso
```python
import autogen

config_list = [{"model": "gpt-4o", "api_key": "..."}]

llm_config = {
    "config_list": config_list,
    "timeout": 120
}

# Rol como AssistantAgent
assistant = autogen.AssistantAgent(
    name="security_auditor",
    system_message=composed_prompt,
    llm_config=llm_config
)

# UserProxy para interacción
user_proxy = autogen.UserProxyAgent(
    name="user",
    human_input_mode="NEVER",
    max_consecutive_auto_reply=10,
    code_execution_config={"work_dir": "workspace"}
)

user_proxy.initiate_chat(
    assistant,
    message="Analiza este código para vulnerabilidades de seguridad: ..."
)
```

## Multi-agente (chain como GroupChat)
```python
groupchat = autogen.GroupChat(
    agents=[spec_writer, implementer, reviewer],
    messages=[],
    max_round=12
)
manager = autogen.GroupChatManager(groupchat=groupchat, llm_config=llm_config)
```

## Instalación
```bash
pip install pyautogen
```

## Notas
- Principalmente orientado a OpenAI / Azure OpenAI
- Soporte experimental para otros backends via LiteLLM
- Ideal para workflows que requieren ejecución de código y feedback loops
