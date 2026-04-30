# Journey Traceability

PhenoProject documents work that spans planning, dispatch, and delivery. Those
flows should be traceable with narrative plus evidence.

## Standard

When a guide or worklog describes a real workflow, include:

- the flow narrative
- the important states or handoff points
- keyframes for the visible states
- a recording or replay for the full interaction
- a stable link back to the work item, spec, or repo change

## Shared Phenotype Pattern

The canonical Phenotype shape is:

- `ShotGallery` for keyframes
- `RecordingEmbed` for recordings
- stable journey and tape ids
- stable asset paths for the evidence bundle

Reference implementation:

- [phenotype-infra journey standard](https://github.com/kooshapari/phenotype-infra/blob/main/docs/governance/journey-traceability-standard.md)
- hwLedger docs, which show the reference `ShotGallery` + `RecordingEmbed`
  pattern in practice

## Why This Matters Here

PhenoProject is the workspace-level coordination repo. Its docs should make it
easy to audit how work moves from spec to execution to completion.

The journey evidence should show:

1. how a work item enters the queue
2. how it gets dispatched or planned
3. how progress is validated
4. what proof exists that the work actually finished

## Adoption Notes

- Use this guide when adding new docs pages for workflow behavior.
- Link from worklogs when the entry describes an evidence-backed flow.
- If a flow does not yet have a recording, say so explicitly rather than
  leaving the doc empty.

