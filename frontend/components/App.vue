<template>
    <div id="app">
        <b-navbar toggleable="md" type="dark" variant="primary">
            <b-container>
                <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

                <b-navbar-brand href="#">TDB</b-navbar-brand>

                <b-collapse is-nav id="nav-collapse">
                    <b-navbar-nav>
                        <b-nav-item to="/backlog">Backlog</b-nav-item>
                        <b-nav-item to="/sprint-planning">Sprint planning</b-nav-item>
                        <b-nav-item to="/history">History</b-nav-item>
                        <b-nav-item to="/courses">Courses</b-nav-item>
                    </b-navbar-nav>
                </b-collapse>
            </b-container>
        </b-navbar>

        <b-container class="mt-4 mb-5">
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
    @font-face {
        font-family: 'HTWBerlin';
        src: url('~fonts/HTWBerlinWeb-Regular.woff') format('woff');
        font-weight: 300;
        font-style: normal;
    }

    @font-face {
        font-family: 'HTWBerlin';
        src: url('~fonts/HTWBerlinWeb-Bold.woff') format('woff');
        font-weight: 700;
        font-style: normal;
    }

    $blue: #0082D1;
    $indigo: #124E78;
    $purple: #C200FB;
    $pink: #BA274A;
    $red: #9A031E;
    $orange: #FF5F00;
    $yellow: #FFCA3A;
    $green: #76B900;
    $teal: #06D6A0;
    $cyan: #6DAEDB;

    $primary: $green;
    $secondary: $blue;

    $enable-rounded: false;

    $font-family-sans-serif: HTWBerlin, Verdana, Arial, sans-serif;
    $headings-font-weight: 700;

    @import "~bootstrap/scss/bootstrap";
    @import "~bootstrap-vue/dist/bootstrap-vue.css";

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

    .fa-icon {
        vertical-align: sub;
    }
</style>