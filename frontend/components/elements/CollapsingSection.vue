<template>
    <BRow class="collapsing-section">
        <BCol md="3" @click="toggle">
            <VIcon
                class="float-right mt-2"
                :name="visible ? 'caret-down' : 'caret-right'"
                scale="2"/>

            <slot name="headline">Headline</slot>
        </BCol>
        <transition name="appear">
            <BCol md="9" v-show="visible">
                <slot name="content">Content</slot>
            </BCol>
        </transition>
    </BRow>
</template>

<script>
import '@icons/caret-down';
import '@icons/caret-right';
import VIcon from 'vue-awesome/components/Icon';
import BRow from '@bootstrap/layout/row';
import BCol from '@bootstrap/layout/col';

export default {
    name: 'CollapsingSection',
    components: { BRow, BCol, VIcon },
    model: {
        prop: 'visible',
        event: 'toggle',
    },
    props: {
        visible: {
            type: Boolean,
            default: false,
        },
    },
    methods: {
        toggle() {
            this.$emit('toggle', !this.visible);
        },
    },
};
</script>

<style scoped>
    .collapsing-section {
        margin-top: 15px;
    }

    .collapsing-section__icon {
        float: right;
    }

    .appear-enter-active, .appear-leave-active {
        transition: all 0.3s;
    }

    .appear-enter, .appear-leave-to {
        transform: translateX(100%);
        opacity: 0;
    }

    .appear-enter-to, .appear-leave {
        transform: translateX(0);
        opacity: 1;
    }

</style>