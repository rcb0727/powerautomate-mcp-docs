---
name: work-queues
description: Coordinate work with Power Automate work queues. Use for work queues, queue items, or when the user wants to distribute or track units of work across flows and bots.
---

# Work queues

A work queue is a shared to-do list between systems and bots — enqueue items, have flows or desktop flows process them, with retries and exception tracking.

## Tools
`list_work_queues` · `get_work_queue` · `create_work_queue` · `enqueue_work_queue_item` · `list_work_queue_items` · `dequeue_work_queue_item` · `update_work_queue_item` · `delete_work_queue`

## Setting one up
1. `create_work_queue` — optionally enforce a JSON schema on item inputs, and set retry/requeue caps.
2. `enqueue_work_queue_item` for each unit of work. `uniqueIdByQueue` prevents duplicates; `delayUntil` holds an item until a time.

## Processing
- `dequeue_work_queue_item` atomically claims the oldest item and flips it to Processing.
- `update_work_queue_item` finishes it: `processed`, or an exception class (`business_exception` for bad data, `it_exception` for a transient failure that should retry, `generic_exception` otherwise), or `requeue` to put it back.
- Always close out a claimed item. An item left Processing blocks nothing else but never completes.

## Monitoring
`get_work_queue` gives counts by state. A growing `error` count means items are failing — `list_work_queue_items` with `state: "error"` shows the exception class and the processing note for each.

## Note
Dataverse may override the `priority` you submit, so treat ordering as best-effort.
