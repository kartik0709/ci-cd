// List journal entries (transactions), most recent first
query "transactions" verb=GET {
  api_group = "Bookkeeping"
  description = "List journal entries (transactions), most recent first"

  input {
    date start_date?="1970-01-01"
    date end_date?="2999-12-31"
    int page?=1 filters=min:1
    int per_page?=25 filters=min:1|max:100
  }

  stack {
    db.query "journal_entry" {
      where = $db.journal_entry.date >=? $input.start_date && $db.journal_entry.date <=? $input.end_date
      sort = { date: "desc" }
      return = { type: "list", paging: { page: $input.page, per_page: $input.per_page, totals: true } }
    } as $entries_page
  }

  response = $entries_page
}
