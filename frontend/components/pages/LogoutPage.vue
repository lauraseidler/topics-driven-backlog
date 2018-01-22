<template>
    <section id="logout-page">
        <h1>Logging you out..</h1>
    </section>
</template>

<script>
export default {
    name: 'logout',
    data() {
        return {};
    },
    methods: {
        logout() {
            this.$store.commit('logout');
            this.$router.push('/');
        },
    },
    mounted() {
        this.logout();
    },
};
</script>