<template>
    <b-form @submit.prevent="submit">
        <b-row>
            <b-col md="10">
                <b-form-group label="Story *" label-for="story-title">
                    <b-form-input id="story-title" v-model="data.title" required></b-form-input>
                </b-form-group>
            </b-col>
            <b-col md="2">
                <b-form-group label="Story points" label-for="story-points">
                    <b-form-input id="story-points" type="number" min="0" v-model="data.points"></b-form-input>
                </b-form-group>
            </b-col>
        </b-row>

        <b-form-group label="Notes" label-for="story-description">
            <b-form-textarea id="story-description" v-model="data.description"></b-form-textarea>
        </b-form-group>

        <b-button type="submit" variant="primary" :disabled="isInvalid">Save</b-button>
        <b-button type="button" variant="grey" @click="cancel">Cancel</b-button>
    </b-form>
</template>

<script>
    import {required, numeric, minValue} from 'vuelidate/lib/validators';
    import BaseForm from './BaseForm.vue';

    export default {
        name: 'story-form',
        extends: BaseForm,
        validations: {
            data: {
                title: {required},
                points: {numeric, minValue: minValue(0)}
            },
        },
    }
</script>