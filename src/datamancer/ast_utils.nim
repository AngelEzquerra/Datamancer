import macros, strutils

template letsGoDeeper* =
  var rTree = node.kind.newTree()
  for child in node:
    rTree.add inspect(child)
  return rTree

proc replaceSymsByIdents*(ast: NimNode): NimNode =
  proc inspect(node: NimNode): NimNode =
    case node.kind:
    of nnkSym:
      let nStr = $node
      if "Column" in nStr or ("Generic" in nStr and "Kind" in nStr):
        return node
      else:
        return ident($node)
    of nnkIdent:
      return node
    of nnkEmpty:
      return node
    of nnkLiterals:
      return node
    of nnkHiddenStdConv: # see `test_fancy_indexing,nim` why needed
      expectKind(node[1], nnkSym)
      return ident($node[1])
    else:
      letsGoDeeper()
  result = inspect(ast)

import macrocache
proc contains*(t: CacheTable, key: string): bool =
  for k, val in pairs(t):
    if k == key: return true
