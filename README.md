# GexLab 使用文档

GexLab 是一个面向 GMod 的 NPC/Ragdoll 互动扩展，包含搜刮系统、面部表情菜单、以及一套体位/动作场景系统。

## 依赖 / 联动

- 可选联动：**EDA**（Enhanced Death Animations）
- 可选联动：**GPEE + GWater2**，启用后部分场景会触发额外的排尿效果
- 不强制依赖，但缺少对应联动时相关功能会跳过或打印提示

## 安装

1. 将 `gexlab` 文件夹放入 `garrysmod/addons/`。
2. 启动游戏后，在服务器控制台或客户端控制台使用下面的命令。

## 控制台命令

| 命令 | 客户端/服务器 | 作用 |
| --- | --- | --- |
| `GexLab_menu` | 客户端 | 对着 NPC / Ragdoll 打开配置菜单，可编辑搜刮表、面部表情、女性标记、黑名单并保存到服务器。 |
| `sex` | 服务器 | 对着 Ragdoll 使用可进入/退出互动场景；已经处于场景时再次使用可退出。 |
| `debugsex` | 服务器 | 调试命令，主要用于开发者检查模型、动作、路径点等。 |

### 推荐绑定

```lua
// 在客户端控制台执行
bind p "GexLab_menu"
bind k "sex"
```

## ConVar

| ConVar | 默认值 | 说明 |
| --- | --- | --- |
| `gex_NPCrapeenable` | 1 | 是否启用 NPC/Ragdoll 自动场景逻辑 |
| `gex_NPClootnable` | 1 | 是否启用 NPC 搜刮 |
| `gex_randlootrhance` | 0.5 | 搜刮时随机获得战利品的概率 |
| `gex_max_time` | 120 | 单次场景最大持续时间（秒） |
| `gex_min_time` | 60 | 单次场景最小持续时间（秒） |
| `gex_Combinedikenable` | 1 | 是否启用模型/额外的“dik”模型绑定 |
| `gex_auto_positionfix_enable` | 1 | 是否启用自动位置修正 |
| `gex_3p_chance` | 50 | 三人/多人场景触发概率（0~100） |
| `gex_gexfacenable` | 1 | 是否启用场景面部表情 |

## 菜单说明

- `GexLab_menu` 打开后可以：
  - 设置每个 Bodygroup 的搜刮状态与权重；
  - 配置 4 个面部表情状态；
  - 标记模型为女性；
  - 将模型加入黑名单；
  - 点击 `save` 将配置发送给服务器保存到 `H_model_presets.txt`。

## 数据文件

- `garrysmod/data/H_model_presets.txt`：保存各模型的面部表情与搜刮设置。
## Z-City 适配说明

- 自动检测：engine.ActiveGamemode() == "zcity" 或存在 hg.Ragdoll_Create 时启用 Z-City 适配。
- 自动 NPC 互动：zcity 下不再要求 ragdoll 有 `reallykilled` 标记，避免与 EDA 共存时跳过所有 zcity 尸体。
- 手动 sex：复用 zcity 的 FakeRagdoll / RagdollDeath 作为演员尸体，不再额外创建布娃娃。
- 修好了 EDA 死亡镜头网络消息：PlayerRag_StartDeathCam / PlayerRag_PlayerSpawn 现在会正确写入玩家实体。

