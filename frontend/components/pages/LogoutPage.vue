<template>
    <section id="logout-page">
        <h1>Logging you out..</h1>
    </section>
</template>

<script>
export default {
    name: 'LogoutPage',
    mounted() {
        this.logout();
    },
    methods: {
        logout() {
            this.$store.commit('logout');
            this.$router.push('/');
        },
    },

};
</script>