<template>
    <div id="app">
        <b-navbar toggleable="md" type="dark" variant="primary">
            <b-container>
                <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

                <b-navbar-brand href="#">TDB</b-navbar-brand>

                <b-collapse is-nav id="nav_collapse">
                    <b-navbar-nav>
                        <b-nav-item to="/stories">Backlog</b-nav-item>
                        <b-nav-item to="/courses">Courses</b-nav-item>
                    </b-navbar-nav>
                </b-collapse>
            </b-container>
        </b-navbar>

        <b-container class="mt-4">
            <router-view></router-view>
        </b-container>
    </div>
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
