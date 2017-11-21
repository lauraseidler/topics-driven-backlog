<template>
    <b-form @submit="$v.value.$invalid || $emit('submit')">
        <b-form-group label="Name" label-for="sprint-name">
            <b-form-input id="sprint-name" v-model="value.name" required></b-form-input>
        </b-form-group>

        <b-form-group label="Start date" label-for="sprint-start-date">
            <b-form-input id="sprint-start-date" type="date" v-model="value.start_date" required></b-form-input>
        </b-form-group>

        <b-form-group label="End date" label-for="sprint-end-date">
            <b-form-input id="sprint-end-date" type="date" v-model="value.end_date" required></b-form-input>
        </b-form-group>

        <b-button type="submit" variant="primary" :disabled="$v.value.$invalid">Save</b-button>
        <b-button type="button" variant="secondary" @click="$emit('cancel')">Cancel</b-button>
    </b-form>
</template>

<script>
    import {required} from 'vuelidate/lib/validators';
    import smallerOrEqualThan from '../../validators/smallerOrEqualThan';
    import largerOrEqualThan from '../../validators/largerOrEqualThan';

    export default {
        name: 'sprint-form',
        props: {
            value: {
                type: Object,
                default: {},
            },
        },
        watch: {
            value: {
                handler: function (newVal) {
                    this.$emit('input', newVal);
                },
                deep: true,
            }
        },
        validations: {
            value: {
                name: {required},
                start_date: {
                    required,
                    smallerThanEnd: smallerOrEqualThan('end_date')
                },
                end_date: {
                    required,
                    largerThanStart: largerOrEqualThan('start_date')
                },
            },
        },
    }
</script>