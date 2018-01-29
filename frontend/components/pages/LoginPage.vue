<template>
    <section id="login-page">
        <h1>Login</h1>

        <LoginForm 
            v-model="user" 
            @submit="login"/>
    </section>
</template>

<script>
import LoginForm from '@/components/forms/LoginForm';

export default {
    name: 'LoginPage',
    components: { LoginForm },
    data() {
        return {
            user: {},
        };
    },
    computed: {
        redirectTo() {
            return this.$route.query.redirectTo || '/';
        },
    },
    methods: {
        async login() {
            try {
                await this.$store.dispatch('login', this.user);

                // redirect to where the user wanted to go
                this.$router.push(this.redirectTo);
            } catch (err) {
                this.$notify({
                    title: 'Login failed',
                    text: err.body.message || 'Please check your username and password.',
                    type: 'error',
                });
            }
        },
    },
};
</script>
