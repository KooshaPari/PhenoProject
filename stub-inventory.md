# PhenoProject Stub Inventory

> Generated 2026-05-05. Scan: TODO/FIXME in `.rs`, `.py`, `.ts`, `.tsx`, `.go` files.
> **Total: 97 TODO/FIXME entries** (plus 1,676 form placeholder entries in generated admin UI).

## Category: Plane/Propel Fork Legacy TODOs (pre-existing, not introduced by Phenotype)

> These are inherited from the Plane (project management) and Propel (AI) forks. Most are in forked third-party packages and do not affect Phenotype functionality.

### `packages/ui/` (5 entries)

| File | Line | Content |
|------|------|---------|
| `packages/ui/src/tooltip/tooltip.tsx` | 53 |   //FIXME: tooltip should always render on hover and not by default, this is a temporary fix |
| `packages/ui/src/dropdowns/helper.tsx` | 7 | // FIXME: fix this!!! |
| `packages/ui/src/breadcrumbs/breadcrumbs.stories.tsx` | 27 | // TODO: remove this component and use web Link component |
| `packages/ui/src/badge/helper.tsx` | 34 | // TODO: convert them to objects instead of enums |
| `packages/ui/src/badge/helper.tsx` | 42 | // TODO: convert them to objects instead of enums |

### `packages/editor/` (7 entries)

| File | Line | Content |
|------|------|---------|
| `packages/editor/src/core/plugins/ai-handle.ts` | 72 |         // TODO FIX ERROR |
| `packages/editor/src/core/plugins/ai-handle.ts` | 86 |     // TODO FIX ERROR |
| `packages/editor/src/core/extensions/custom-color.ts` | 117 |   // TODO: check this and update types |
| `packages/editor/src/core/extensions/trailing-node.ts` | 14 |   // TODO: check this logic, might be wrong |
| `packages/editor/src/core/extensions/code/lowlight-plugin.ts` | 7 | // TODO: check all the type errors and fix them |
| `packages/editor/src/core/extensions/code/code-block.ts` | 341 |                 // TODO: complicated paste logic, to be handled later |
| `packages/editor/src/core/extensions/table/plugins/drag-handles/color-selector.tsx` | 17 | // TODO: implement text color selector |

### `packages/types/` (2 entries)

| File | Line | Content |
|------|------|---------|
| `packages/types/src/view-props.ts` | 156 |   layout?: any; // TODO: Need to fix this and set it to enum EIssueLayoutTypes |
| `packages/types/src/index.ts` | 32 | export * from "./issues/base"; // TODO: Remove this after development and the refactor/mobx-store-is |

### `packages/utils/` (1 entries)

| File | Line | Content |
|------|------|---------|
| `packages/utils/src/string.ts` | 359 |     // FIXME: Even though we are using this as a fallback, execCommand is deprecated 👎. We should fi |

### `packages/propel/` (1 entries)

| File | Line | Content |
|------|------|---------|
| `packages/propel/src/banner/helper.tsx` | 20 | // TODO: update this with new color once its implemented |

### `apps/api/` (13 entries)

| File | Line | Content |
|------|------|---------|
| `apps/api/plane/app/permissions/workspace.py` | 18 | # TODO: Move the below logic to python match - python v3.10 |
| `apps/api/plane/app/serializers/issue.py` | 80 | ##TODO: Find a better way to write this serializer |
| `apps/api/plane/app/views/cycle/base.py` | 500 |         # TODO: Soft delete the cycle break the onetoone relationship with cycle issue |
| `apps/api/plane/app/views/estimate/base.py` | 156 |         #  TODO: add a key validation if the same key already exists |
| `apps/api/plane/app/views/estimate/base.py` | 172 |         #  TODO: add a key validation if the same key already exists |
| `apps/api/plane/app/views/analytic/advance.py` | 88 |                     issue_intake__status__in=["-2", "-1", "0", "1", "2"]  # TODO: Add description fo |
| `apps/api/plane/bgtasks/notification_task.py` | 254 |                     # TODO: Maybe save the comment mentions, so that in future, we can filter out th |
| `apps/api/plane/bgtasks/export_task.py` | 41 | # TODO: Change the upload_to_s3 function to use the new storage method with entry in file asset tabl |
| `apps/api/plane/utils/permissions/workspace.py` | 18 | # TODO: Move the below logic to python match - python v3.10 |
| `apps/api/plane/db/models/issue.py` | 91 | # TODO: Handle identifiers for Bulk Inserts - nk |
| `apps/api/plane/db/models/project.py` | 263 | # TODO: Remove workspace relation later |
| `apps/api/plane/db/models/project.py` | 298 | # DEPRECATED TODO: |
| `apps/api/plane/space/serializer/issue.py` | 241 | ##TODO: Find a better way to write this serializer |

