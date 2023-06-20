<template>
  <q-page padding>
    <div class="q-pa-md">
      <q-table
        flat
        title="My Orders"
        :rows="rows"
        :columns="columns"
        row-key="id"
        hide-pagination
        :pagination="{rowsPerPage: 0}"
        @row-click="(_, row) => goToOrder(row.id)"
        table-header-class="text-amber-14"
        card-class="bg-amber-1 q-pa-md">
        <template v-slot:top>
          <q-space />
          <q-btn
            :loading="loading"
            flat round dense
            icon="refresh"
            @click="fetchData"
            class="q-ml-md"
          />
        </template>
      </q-table>
    </div>
  </q-page>
</template>

<script>
import { api } from 'boot/axios'

const columns = [
  {
    name: 'id',
    required: true,
    label: 'ID',
    align: 'left',
    field: row => row.id,
    format: val => `${val}`.slice(0, 8),
    sortable: false
  },
  {
    name: 'createTime',
    label: 'Create Time',
    field: 'createTime',
    sortable: true,
    format: val => new Date(val).toLocaleString(),
    sortOrder: 'da'
  },
  { name: 'status', label: 'Status', field: 'status' },
  { name: 'currency', label: 'Currency', field: 'currency' },
  {
    name: 'discount',
    label: 'Discount',
    field: 'discount',
    format: (val) => val.toFixed(2)
  },
  {
    name: 'deliveryCost',
    label: 'Delivery Cost',
    field: 'deliveryCost',
    format: (val) => val.toFixed(2)
  }
]

export default {

  setup () {
    return {
      columns
    }
  },

  data () {
    return {
      rows: [],
      loading: false
    }
  },

  created() {
    // watch the params of the route to fetch the data again
    this.$watch(
      () => this.$route.params,
      () => {
        this.fetchData()
      },
      // fetch the data when the view is created and the data is
      // already being observed
      { immediate: true }
    )
  },

  methods: {
    fetchData () {
      this.loading = true
      api
        .get('/v1/orders?customerId=a13dfdb8-6e30-4d31-99e4-62c3a308e310&sortOrder=DESC')
        .then(response => {
          this.loading = false
          this.rows = response.data.results
        })
        .catch(() => {
          this.loading = false
          this.$q.notify({
            color: 'negative',
            position: 'top',
            message: 'Failed to load orders!',
            icon: 'report_problem'
          })
        })
    },

    goToOrder (id) {
      console.log(id)
      this.$router.push({ path: '/order', query: { id } })
    }
  }
}
</script>
