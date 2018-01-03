<template>
    <BForm 
        @submit.prevent="submit" 
        class="sprint-form">

        <BFormGroup 
            label="Name" 
            label-for="sprint-name">

            <BFormInput 
                id="sprint-name" 
                v-model="data.name" 
                required/>
        </BFormGroup>

        <BFormGroup 
            label="Start date" 
            label-for="sprint-start-date">

            <BFormInput 
                id="sprint-start-date" 
                :max="data.end_date" 
                type="date" 
                v-model="data.start_date" 
                required/>
        </BFormGroup>

        <BFormGroup 
            label="End date" 
            label-for="sprint-end-date">

            <BFormInput 
                id="sprint-end-date" 
                type="date" 
                v-model="data.end_date" 
                required
                :min="$store.state.currentDate > data.start_date ? $store.state.currentDate : data.start_date"/>
        </BFormGroup>

        <BButton 
            type="submit" 
            variant="primary" 
            :disabled="isInvalid">Save</BButton>

        <BButton 
            type="button" 
            variant="grey" 
            @click="cancel">Cancel</BButton>
    </BForm>
</template>

<script>
import moment from 'moment';
import { required } from 'vuelidate/lib/validators';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BButton from '@bootstrap/button/button';
import smallerOrEqualThan from '@/validators/smallerOrEqualThan';
import largerOrEqualThan from '@/validators/largerOrEqualThan';
import BaseForm from '@/components/forms/BaseForm';

export default {
    name: 'SprintForm',
    components: { BForm, BFormGroup, BFormInput, BButton },
    extends: BaseForm,
    validations: {
        data: {
            name: { required },
            start_date: {
                required,
                smallerThanEnd: smallerOrEqualThan('end_date'),
            },
            end_date: {
                required,
                largerThanStart: largerOrEqualThan('start_date'),
                largerThanToday: largerOrEqualThan(
                    moment().format('YYYY-MM-DD'),
                    true
                ),
            },
        },
    },
};
</script>