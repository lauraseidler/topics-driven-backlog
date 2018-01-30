<template>
    <BForm 
        @submit.prevent="submit" 
        class="topic-form">

        <BFormGroup 
            label="Name" 
            label-for="topic-title">

            <BFormInput 
                id="topic-title"
                v-model="data.title"
                required/>
        </BFormGroup>

        <BFormGroup
            label="Link"
            label-for="topic-url">

            <BFormInput
                id="topic-url"
                type="url"
                v-model="data.url"/>
        </BFormGroup>

        <BButton 
            type="submit" 
            variant="primary" 
            :class="{ 'is-disabled': isInvalid }">Save</BButton>

        <BButton 
            type="button" 
            variant="grey" 
            @click="cancel">Cancel</BButton>
    </BForm>
</template>

<script>
import { required, url } from 'vuelidate/lib/validators';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BButton from '@bootstrap/button/button';
import BaseForm from '@/components/forms/BaseForm';

export default {
    name: 'TopicForm',
    components: { BForm, BFormGroup, BFormInput, BButton },
    extends: BaseForm,
    validations: {
        data: {
            title: { required },
            url: { url },
        },
    },
};
</script>