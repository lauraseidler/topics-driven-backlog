<template>
    <section id="not-found">
        <h1>The page you're trying to view does not exist.</h1>

        <p>You can:</p>

        <ul>
            <li><router-back>Go back</router-back></li>
            <li><router-link to="/">Go to homepage</router-link></li>
        </ul>
    </section>
</template>

<script>
    export default {
        name: 'not-found'
    }
</script>