// List journal entries (transactions), most recent first
query "transactions" verb=GET {
  api_group = "Bookkeeping"
  description = "List journal entries (transactions), most recent first"

  input {
    date start_date?
    date end_date?
    int page?=1 filters=min:1
    int per_page?=25 filters=min:1|max:100
  }

  stack {
    var $start_date { value = $input["start_date"] }
    var $end_date { value = $input["end_date"] }

    db.query "journal_entry" {
      where = $db.journal_entry.date >=? $start_date && $db.journal_entry.date <=? $end_date
      sort = { date: "desc" }
      return = { type: "list", paging: { page: $input.page, per_page: $input.per_page, totals: true } }
    } as $entries_page
  }

  response = $entries_page
}
