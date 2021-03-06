<template>
    <table class="story-table table table-striped mb-4">
        <thead>
            <tr>
                <th 
                    @click="sortBy(column.field)" 
                    v-for="(column, index) in columns" 
                    :key="index"
                    :title="view === 'print' ? '' : 'Click to sort'">

                    <nobr>
                        {{ column.name }}
                        <template v-if="view !== 'print'">
                            <VIcon
                                v-if="currentSort.field === column.field && currentSort.order === -1"
                                name="caret-up"/>
                            <VIcon
                                v-else-if="currentSort.field === column.field && currentSort.order === 1"
                                name="caret-down"/>
                            <VIcon
                                v-else-if="column.field"
                                name="caret-down"
                                :class="$style.fade"/>
                        </template>
                    </nobr>
                </th>
            </tr>
        </thead>
        <tbody v-sortable="sortable ? { handle: '.js-drag-drop', onEnd: saveOrder } : false">
            <tr
                is="StoryItem"
                v-for="story in sortedAndMovedRows"
                :key="story.id"
                :data="story"
                :position="typeof moving[story.id] !== 'undefined' ? null : mappedFields(positionField).indexOf(story[positionField]) + 1"
                :sortable="sortable && currentSort.field === positionField && currentSort.order === 1"
                :view="view"
                :highlight="highlight === story.id"
                @moveStart="moveStart"
                @move="move"
                @moveComplete="moveComplete"
                @moveAbort="moveAbort"/>
        </tbody>
    </table>
</template>

<script>
import '@icons/caret-up';
import '@icons/caret-down';
import VIcon from 'vue-awesome/components/Icon';
import StoryItem from '@/components/elements/StoryItem';

export default {
    name: 'StoryTable',
    components: { StoryItem, VIcon },
    props: {
        columns: {
            type: Array,
            default: function () {
                return [];
            },
        },
        rows: {
            type: Array,
            default: function () {
                return [];
            },
        },
        view: {
            type: String,
            default: null,
        },
        sortable: {
            type: Boolean,
            default: false,
        },
        positionField: {
            type: String,
            default: null,
        },
    },
    data() {
        return {
            currentSort: {
                field: null,
                order: 1,
            },
            moving: {},
            highlight: null,
        };
    },
    computed: {
        sortedRows() {
            if (this.currentSort.field && this.rows.length > 1) {
                if (typeof this.rows.slice()[0][this.currentSort.field] === 'number') {
                    return this.rows.slice().sort((a, b) =>
                        (a[this.currentSort.field] - b[this.currentSort.field])
                        * this.currentSort.order
                    );
                } else {
                    return this.rows.slice().sort((a, b) =>
                        (a[this.currentSort.field] + '').localeCompare(b[this.currentSort.field] + '')
                            * this.currentSort.order
                    );
                }

            } else {
                return this.rows;
            }
        },

        sortedAndMovedRows() {
            if (Object.keys(this.moving).length) {
                const rows = this.sortedRows.slice();

                Object.keys(this.moving).forEach(id => {
                    const indexById = this.indexById(parseInt(id, 10));

                    const newObj = Object.assign(
                        {},
                        rows[indexById],
                        {
                            [this.positionField]:
                                this.mappedFields(this.positionField)[indexById + this.moving[id]]
                                + Math.sign(this.moving[id]),
                        },
                    );

                    this.$set(
                        rows,
                        indexById,
                        newObj
                    );
                });

                return rows.sort((a, b) =>
                    (a[this.positionField] - b[this.positionField])
                );
            } else {
                return this.sortedRows;
            }
        },
    },
    created() {
        this.resetSort();
    },
    methods: {
        mappedFields(field) {
            return this.rows.map(i => i[field]);
        },

        sortBy(field) {
            if (this.view !== 'print' && field) {
                if (this.currentSort.field === field) {
                    if (this.currentSort.order === 1) {
                        this.currentSort.order = -1;
                    } else {
                        this.resetSort();
                    }
                } else {
                    this.currentSort.field = field;
                    this.currentSort.order = 1;
                }
            }
        },

        resetSort() {
            this.currentSort.field = null;
            this.currentSort.order = 1;

            if (this.positionField) {
                this.sortBy(this.positionField);
            }
        },

        indexById(id) {
            return this.sortedRows.findIndex(i => i.id === id);
        },

        move(id, direction) {            
            if (!this.moving[id]) {
                this.$set(this.moving, id, 0);
            }

            let newMoving = this.moving[id] += direction;

            if (this.indexById(id) + newMoving < 0) {
                newMoving += 1;
            } else if (this.indexById(id) + newMoving >= this.sortedRows.length) {
                newMoving -= 1;
            }

            this.$set(this.moving, id, newMoving);
        },

        moveStart(id) {
            this.$set(this.moving, id, 0);
        },

        async moveComplete(id) {
            await this.saveOrder({
                oldIndex: this.indexById(id),
                newIndex: this.indexById(id) + this.moving[id],
            });

            this.$delete(this.moving, id);
        },

        moveAbort(id) {
            this.$delete(this.moving, id);
        },

        /**
         * Save new position of dragged story
         * @param {Event} evt
         */
        async saveOrder(evt) {
            const story = this.rows[evt.oldIndex];

            if (!story) {
                return;
            }

            try {
                await this.$store.dispatch('stories/update', {
                    id: story.id,
                    parentId: story.project_id,
                    [this.positionField]: this.mappedFields(this.positionField)[evt.newIndex],
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Story update failed',
                    text: err.body.message,
                    type: 'error',
                });
            }

            this.highlight = story.id;

            setTimeout(() => {
                this.highlight = null;
            }, 1000);

            try {
                await this.$store.dispatch('projects/fetch', {
                    id: story.project_id,
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Project reload failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
        },
    },
};
</script>

<style scoped>
    th {
        cursor: pointer;
    }
</style>

<style module>
    .fade {
        fill: #ccc !important;
    }
</style>