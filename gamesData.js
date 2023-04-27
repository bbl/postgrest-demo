import {PostgrestClient} from '@supabase/postgrest-js'

const REST_URL = 'http://localhost:3000'

const pg = new PostgrestClient(REST_URL)


const getPagination = (page, size) => {
    const limit = size ? +size : 3
    const from = page ? page * limit : 0
    const to = page ? from + size - 1 : size - 1

    return {from, to}
}

async function queryGamesTable(rangeFrom, rangeTo, sortAsc, sortCol) {
    console.log(`from: ${rangeFrom}, to: ${rangeTo}`)

    let query = pg
        .from('games')
        .select()

    if (sortAsc !== null && sortCol !== null) {
        query = query.order(sortCol, {ascending: sortAsc})
    }

    const {data, error} = await query.range(rangeFrom, rangeTo)
    if (error !== null) {
        console.log(`query error: ${error}`)
    }
    return data
}

export function GamesData() {
    return {

        records: null,
        pageSize: 5,

        curPage: 0,
        count: null,

        sortCol: null,
        sortAsc: null,

        async init() {
            const {data, count} = await pg
                .from("games")
                .select("*", {count: "exact"})
                .limit(this.pageSize)
            this.records = data
            this.count = count
        },

        async sort(col) {
            this.curPage = 0
            const {from, to} = getPagination(this.curPage, this.pageSize)
            if (this.sortCol === col) {
                if (this.sortAsc === true) {
                    this.sortAsc = false
                } else if (this.sortAsc === false) {
                    this.sortAsc = null
                } else if (this.sortAsc === null) {
                    this.sortAsc = true
                }
            } else {
                this.sortCol = col
                this.sortAsc = true
            }

            this.records = await queryGamesTable(from, to, this.sortAsc, this.sortCol)
        },

        async nextPage() {
            this.curPage++

            const {from, to} = getPagination(this.curPage, this.pageSize)

            this.records = await queryGamesTable(from, to, this.sortAsc, this.sortCol)
        },

        async previousPage() {
            if (this.curPage === 0) {
                return
            }
            this.curPage--

            const {from, to} = getPagination(this.curPage, this.pageSize)
            this.records = await queryGamesTable(from, to, this.sortAsc, this.sortCol)
        }
    }
}

