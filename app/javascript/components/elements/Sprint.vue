<template>
    <li class="card">
        <div class="card-body">
            <template v-if="!editing">
                <b-button size="sm" class="float-right" @click="startEditing">Edit</b-button>

                <h3 class="card-title h5">{{ data.name }}</h3>

                <p class="card-text">
                    Start: {{ data.start_date }} <br>
                    End: {{ data.end_date }}
                </p>
            </template>
            <sprint-form v-else v-model="editingData" @cancel="editing = false" @submit="saveSprint"></sprint-form>
        </div>
    </li>
</template>

<script>
    import SprintForm from "../forms/SprintForm.vue";
    import * as _ from "lodash";

    export default {
        components: {SprintForm},
        name: 'sprint',
        props: ['data'],
        data() {
            return {
                editing: false,
                editingData: null,
            }
        },
        methods: {
            startEditing() {
                this.editing = true;
                this.editingData = _.pick(this.data, ['name', 'start_date', 'end_date']);
            },
            saveSprint() {
                this.$store.dispatch('sprints/patch', {
                    id: this.data.id,
                    values: this.editingData,
                }).then(() => {
                    this.editing = false;
                });
            },
        }
    }
</script>

<style lang="scss">
</style>