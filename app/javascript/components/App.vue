<template>
    <div id="app">
        <router-view></router-view>
    </div>
</template>

<script>
    export default {
        data() {
            return {};
        }
    }
</script>

<style>
    body {
        font-family: sans-serif;
    }

    table {
        border: 1px solid black;
        border-collapse: collapse;
        min-width: 700px;
        max-width: 100vw;
    }

    thead th {
        border-bottom: 1px solid grey;
        border-right: 1px solid grey;
    }

    thead th:last-child {
        border-right: none;
    }

    th, td {
        padding: 10px 15px;
    }

    td[colspan] {
        text-align: center;
    }
</style>
