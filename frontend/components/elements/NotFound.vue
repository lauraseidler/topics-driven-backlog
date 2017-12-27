<template>
    <section class="not-found">
        <h1>The page you're trying to view does not exist.</h1>

        <p>You can:</p>

        <ul>
            <li><RouterBack>Go back</RouterBack></li>
            <li><router-link to="/">Go to homepage</router-link></li>
        </ul>
    </section>
</template>

<script>
import RouterBack from '@/components/elements/RouterBack';

export default {
    name: 'NotFound',
    components: { RouterBack },
};
</script>