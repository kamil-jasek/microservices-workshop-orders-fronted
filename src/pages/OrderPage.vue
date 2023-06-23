<template>
  <q-page padding>
    <q-card class="row bg-amber-1 q-pa-lg q-mb-md" flat>

      <div class="col q-pa-md">
        <div class="text-h5 q-mb-lg text-amber-14">Basic Info</div>
        <div class="row">
          <div class="col-3 text-left" style="font-size: 16px">Order ID</div>
          <div class="col-9 text-left q-pl-md" style="font-size: 16px">{{`${order.id}`.slice(0, 8)}}</div>
        </div>
        <q-separator color="amber-6" class="q-mt-md q-mb-md" />
        <div class="row">
          <div class="col-3 text-left" style="font-size: 16px">Create Time</div>
          <div class="col-9 text-left q-pl-md" style="font-size: 16px">
            {{order.createTime !== undefined ? new Date(order.createTime).toLocaleString() : ''}}
          </div>
        </div>
        <q-separator color="amber-6" class="q-mt-md q-mb-md" />
        <div class="row">
          <div class="col-3 text-left" style="font-size: 16px">Status</div>
          <div class="col-9 text-left q-pl-md" style="font-size: 16px">{{order.status}}</div>
        </div>
        <q-separator color="amber-6" class="q-mt-md q-mb-md" />
        <div class="row">
          <div class="col-3 text-left" style="font-size: 16px">Currency</div>
          <div class="col-9 text-left q-pl-md" style="font-size: 16px">{{order.currency}}</div>
        </div>
        <q-separator color="amber-6" class="q-mt-md q-mb-md" />
        <div class="row">
          <div class="col-3 text-left" style="font-size: 16px">Discount</div>
          <div class="col-9 text-left q-pl-md" style="font-size: 16px">{{order.discount !== undefined ? order.discount.toFixed(2) : ''}}</div>
        </div>
        <q-separator color="amber-6" class="q-mt-md q-mb-md" />
      </div>

      <div class="col q-pa-md">
        <div class="text-h5 q-mb-lg text-amber-14">Additional Info</div>
        <template v-if="order.sentTime">
          <div class="row">
            <div class="col-3 text-left" style="font-size: 16px">Sent Time</div>
            <div class="col-9 text-left q-pl-md" style="font-size: 16px">
              {{new Date(order.sentTime).toLocaleString()}}
            </div>
          </div>
          <q-separator color="amber-6" class="q-mt-md q-mb-md" />
          <div class="row">
            <div class="col-3 text-left" style="font-size: 16px">Shipment ID</div>
            <div class="col-9 text-left q-pl-md" style="font-size: 16px">
              {{`${order.shipmentId}`.slice(0, 8)}}
            </div>
          </div>
          <q-separator color="amber-6" class="q-mt-md q-mb-md" />
        </template>

        <template v-if="order.cancelTime">
          <div class="row">
            <div class="col-3 text-left" style="font-size: 16px">Cancel Time</div>
            <div class="col-9 text-left q-pl-md" style="font-size: 16px">
              {{new Date(order.cancelTime).toLocaleString()}}
            </div>
          </div>
          <q-separator color="amber-6" class="q-mt-md q-mb-md" />
          <div class="row">
            <div class="col-3 text-left" style="font-size: 16px">Cancel Reason</div>
            <div class="col-9 text-left q-pl-md" style="font-size: 16px">{{order.cancelReason}}</div>
          </div>
          <q-separator color="amber-6" class="q-mt-md q-mb-md" />
        </template>
      </div>
    </q-card>

    <q-table
      flat
      title="Ordered products"
      :rows="orderItems"
      :columns="columns"
      row-key="id"
      hide-pagination
      :pagination="{rowsPerPage: 0}"
      @row-click="(_, row) => goToOrder(row.id)"
      card-class="bg-amber-1 q-pa-md">
      <template v-slot:top>
        <div class="q-table__title text-amber-14">Ordered Products</div>
      </template>
    </q-table>
  </q-page>
</template>

<script>
import { api } from 'boot/axios'

const columns = [
  {
    name: 'id',
    required: true,
    label: 'Product ID',
    align: 'left',
    field: row => row.id,
    format: val => `${val}`.slice(0, 8),
    sortable: false
  },
  {
    name: 'originalPrice',
    required: true,
    label: 'Original Price',
    align: 'left',
    field: 'originalPrice',
    format: val => val.toFixed(2),
    sortable: false
  },
  {
    name: 'originalCurrency',
    required: true,
    label: 'Original Currency',
    align: 'left',
    field: 'originalCurrency',
    format: val => val,
    sortable: false
  },
  {
    name: 'exchangedPrice',
    required: true,
    label: 'Exchanged Price',
    align: 'left',
    field: 'exchangedPrice',
    format: val => val.toFixed(2),
    sortable: false
  },
  {
    name: 'weight',
    required: true,
    label: 'Single Product Weight',
    align: 'left',
    field: 'weight',
    format: val => val.toFixed(2),
    sortable: false
  },
  {
    name: 'weightUnit',
    required: true,
    label: 'Weight Unit',
    align: 'left',
    field: 'weightUnit',
    format: val => val,
    sortable: false
  },
  {
    name: 'quantity',
    required: true,
    label: 'Quantity',
    align: 'left',
    field: 'quantity',
    format: val => val,
    sortable: false
  },
]

export default {

  setup () {
    return {
      columns
    }
  },

  data () {
    return {
      order: {},
      orderItems: []
    }
  },

  created() {
    // watch the params of the route to fetch the data again
    this.$watch(
      () => this.$route.params,
      () => {
        const id = this.$route.query.id
        if (id !== undefined) {
          this.fetchOrder(id)
          this.fetchOrderItems(id)
        }
      },
      // fetch the data when the view is created and the data is
      // already being observed
      { immediate: true }
    )
  },

  methods: {
    fetchOrder (id) {
      api
        .get(`/v1/orders/${id}`)
        .then(response => {
          this.order = response.data
        })
        .catch(() => {
          this.$q.notify({
            color: 'negative',
            position: 'top',
            message: `Failed to load order: ${id}`,
            icon: 'report_problem'
          })
        })
    },

    fetchOrderItems (id) {
      api
        .get(`/v1/orders/${id}/items`)
        .then(response => {
          this.orderItems = response.data.results
        })
        .catch(() => {
          this.$q.notify({
            color: 'negative',
            position: 'top',
            message: `Failed to load order items: ${id}`,
            icon: 'report_problem'
          })
        })
    }
  }
}
</script>

