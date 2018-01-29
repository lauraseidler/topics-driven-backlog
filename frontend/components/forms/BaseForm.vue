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
            default: function ()  {
                return {};
            },
        },
    },
    computed: {
        isInvalid() {
            return this.$v && this.$v.$invalid;
        },
    },
    watch: {
        data: {
            handler: function(newVal) {
                this.$emit('input', newVal);
            },
            deep: true,
        },
    },
    mounted() {
        if (this.$refs.focusInput && this.$refs.focusInput.$el) {
            this.$refs.focusInput.$el.focus();
        }
    },
    methods: {
        /**
         * If validations are given, validate, and emit submit event if valid
         */
        submit() {
            if (this.$v && this.isInvalid) {
                return;
            }

            this.$emit('submit');
        },

        /**
         * Emit cancel event
         */
        cancel() {
            this.$emit('cancel');
        },
    },
};
</script>