<script>
    export default {
        name: 'router-back',

        render(createElement) {

            const $root = this.$root;

            return createElement(
                // Tag
                this.tag,

                // Attributes
                {
                    attrs: Object.assign({
                        href: this.tag === 'a' ? 'javascript:' : null,
                        type: this.tag === 'button' ? 'button' : null
                    }, this.$attrs),
                    on: {
                        click() {
                            $root.$router.back();
                        }
                    }
                },

                // Children
                this.$slots.default
            );
        },

        props: {
            'tag': {
                type: String,
                default: 'a'
            }
        },
    }
</script>