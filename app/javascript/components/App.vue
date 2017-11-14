<template>
    <b-container class="mt-4">
        <router-view></router-view>
    </b-container>
</template>

<script>
    export default {
        data() {
            return {};
        }
    }
</script>

<style lang="scss">
    @import "~bootstrap/scss/bootstrap";

    .link-unstyled {
        color: inherit;
        text-decoration: inherit;

        &:hover {
            color: $primary;
            text-decoration: none;
        }
    }

    .b-dropdown-minimal {
        .btn {
            padding: 0;
        }

        .dropdown-item {
            padding-left: 5px;
            padding-right: 5px;
        }
    }
</style>
