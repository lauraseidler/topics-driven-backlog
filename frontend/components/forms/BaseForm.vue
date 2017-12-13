<template>
    <p>BaseForm can't be instantiated!</p>
</template>

<script>
    export default {
        model: {
            prop: 'data',
            event: 'input',
        },
        props: {
            data: {
                type: Object,
                default: {},
            },
        },
        computed: {
            isInvalid() {
                return this.$v.$invalid;
            }
        },
        watch: {
            data: {
                handler: function (newVal) {
                    this.$emit('input', newVal);
                },
                deep: true,
            },
        },
        methods: {
            submit() {
                if (this.$v && this.isInvalid) {
                    return;
                }

                this.$emit('submit');
            },
            cancel() {
                this.$emit('cancel');
            },
        },
    };
</script>