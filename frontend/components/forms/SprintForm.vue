<template>
    <b-form @submit.prevent="submit">
        <b-form-group label="Name" label-for="sprint-name">
            <b-form-input id="sprint-name" v-model="data.name" required></b-form-input>
        </b-form-group>

        <b-form-group label="Start date" label-for="sprint-start-date">
            <b-form-input id="sprint-start-date" :max="data.end_date" type="date" v-model="data.start_date" required></b-form-input>
        </b-form-group>

        <b-form-group label="End date" label-for="sprint-end-date">
            <b-form-input id="sprint-end-date" type="date" v-model="data.end_date" required
                          :min="$store.state.currentDate > data.start_date ? $store.state.currentDate : data.start_date"></b-form-input>
        </b-form-group>

        <b-button type="submit" variant="primary" :disabled="isInvalid">Save</b-button>
        <b-button type="button" variant="grey" @click="cancel">Cancel</b-button>
    </b-form>
</template>

<script>
    import {required} from 'vuelidate/lib/validators';
    import smallerOrEqualThan from '../../validators/smallerOrEqualThan';
    import largerOrEqualThan from '../../validators/largerOrEqualThan';
    import BaseForm from './BaseForm.vue';
    import moment from "moment";

    export default {
        name: 'sprint-form',
        extends: BaseForm,
        validations: {
            data: {
                name: {required},
                start_date: {
                    required,
                    smallerThanEnd: smallerOrEqualThan('end_date')
                },
                end_date: {
                    required,
                    largerThanStart: largerOrEqualThan('start_date'),
                    largerThanToday: largerOrEqualThan(moment().format('YYYY-MM-DD'), true),
                },
            },
        },
    }
</script>