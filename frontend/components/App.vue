<template>
    <div id="app">
        <BNavbar 
            toggleable="md" 
            type="dark" 
            variant="primary">

            <BContainer>
                <BNavbarToggle target="nav-collapse"/>

                <BNavbarBrand to="/">
                    Topics Driven Backlog
                </BNavbarBrand>

                <BCollapse 
                    is-nav 
                    id="nav-collapse">
                    
                    <BNavbarNav>
                        <BNavItem to="/projects">Projects</BNavItem>
                        <BNavItem to="/courses">Courses</BNavItem>
                    </BNavbarNav>

                    <BNavbarNav class="ml-auto">
                        <BNavItem href="https://www.htw-berlin.de" target="_blank">
                            <img src="~images/logo-htw.png" alt="HTW Berlin" class="d-inline-block align-top">
                        </BNavItem>
                    </BNavbarNav>
                </BCollapse>
            </BContainer>
        </BNavbar>

        <BContainer class="mt-4 mb-5">
            <router-view/>
            <notifications position="top center"/>
        </BContainer>
    </div>
</template>

<script>
import BNavbar from '@bootstrap/navbar/navbar';
import BContainer from '@bootstrap/layout/container';
import BNavbarToggle from '@bootstrap/navbar/navbar-toggle';
import BNavbarBrand from '@bootstrap/navbar/navbar-brand';
import BCollapse from '@bootstrap/collapse/collapse';
import BNavbarNav from '@bootstrap/navbar/navbar-nav';
import BNavItem from '@bootstrap/nav/nav-item';

export default {
    components: {
        BNavbar,
        BContainer,
        BNavbarToggle,
        BNavbarBrand,
        BCollapse,
        BNavbarNav,
        BNavItem,
    },
    data() {
        return {};
    },
};
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

$blue: #0082d1;
$indigo: #124e78;
$purple: #c200fb;
$pink: #ba274a;
$red: #9a031e;
$orange: #ff5f00;
$yellow: #ffca3a;
$green: #76b900;
$teal: #06d6a0;
$cyan: #6daedb;

$primary: $green;
$secondary: $blue;

$enable-rounded: true;

$font-family-sans-serif: HTWBerlin, Verdana, Arial, sans-serif;
$headings-font-weight: 700;

@import '~bootstrap/scss/bootstrap';
// @import "~bootstrap-vue/dist/bootstrap-vue.css"; // necessary?

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

.btn .fa-icon {
    margin-right: 3px;
}

.is-disabled {
    opacity: 0.5;
}

.vue-notification {
    font-size: 16px;
}
</style>
