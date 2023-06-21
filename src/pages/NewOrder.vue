<template>
  <q-page padding class="row justify-center items-center q-gutter-lg">
    <q-btn :loading="loading" color="green" label="SUCCESS ORDER" size="30px" unelevated @click="createOrder(SUCCESS_ORDER)" />
    <q-btn :loading="loading" color="orange" label="CANCELED ORDER" size="30px" unelevated @click="createOrder(FAILED_ORDER)" />
  </q-page>
</template>

<script>
import { api } from 'boot/axios'

const SUCCESS_ORDER = {
  "customerId": "a13dfdb8-6e30-4d31-99e4-62c3a308e310",
  "orderCurrency": "USD",
  "orderItems": [
    {
      "productId": "c58b7367-207a-471c-b000-13f67f20c9ca",
      "price": {
        "value": "24.12",
        "currency": "EUR"
      },
      "weight": {
        "value": 0.12,
        "unit": "KG"
      },
      "quantity": 2
    }
  ],
  "discountCoupon": "ABC20"
}

const FAILED_ORDER = {
  "customerId": "a13dfdb8-6e30-4d31-99e4-62c3a308e310",
  "orderCurrency": "USD",
  "orderItems": [
    {
      "productId": "3b1ad028-d67b-4ea4-a7eb-c51b268b277e",
      "price": {
        "value": "24.12",
        "currency": "EUR"
      },
      "weight": {
        "value": 0.12,
        "unit": "KG"
      },
      "quantity": 2
    }
  ],
  "discountCoupon": "ABC20"
}

export default {

  setup () {
    return {
      SUCCESS_ORDER, FAILED_ORDER
    }
  },

  data () {
    return {
      loading: false
    }
  },

  methods: {
    createOrder (order) {
      this.loading = true
      api
        .post('/v1/orders', order)
        .then(response => {
          this.loading = false
          this.$q.notify({
            color: 'green',
            position: 'top',
            message: 'Order created successfully!',
            icon: 'done'
          })
        })
        .catch(() => {
          this.loading = false
          this.$q.notify({
            color: 'negative',
            position: 'top',
            message: 'Failed to create order!',
            icon: 'report_problem'
          })
        })
    }
  }
}
</script>
