<template>
  <div class="list">
      <h6>{{ list.name }}</h6>
      <hr>
      
      <draggable v-model="list.cards" :options="{group: 'cards'}" class="dragArea" @change="cardMoved">
        <div v-for="(card, index) in list.cards" class="card card-body mb-3">
        {{ card.name }}
        </div>
      </draggable>

      
        <textarea v-model="messages" class="form-control mb-1"></textarea>
        <button v-on:click="submitMessage" class="btn btn-primary">Save</button>
       
  </div>
</template>

<script>
import draggable from 'vuedraggable'
export default {
  components: { draggable },
  props: ["lists"],

  data: function() {
    return {
      message: ""
    }
  },

  methods: {
  cardMoved: function(event) {
    const evt = event.added || event.moved 

    if (evt == undefined) { return }

    const element = evt.element

    const list_index = window.store.lists.findIndex((list) => {
      return list.cards.find((card) => {
        return card.id === element.id
      });
    });

    var data = new FormData
    data.append("card[list_id]", window.store.lists[list_index].id)
    data.append("card[position]", evt.newIndex + 1)

    Rails.ajax({
      url: `/cards/${element.id}/move`,
      type: "PATCH",
      data: data,
      dataType: "json"
    })
  },

    submitMessage: function() {
    var data = new FormData
    data.append("card[list_id]", this.list_id)
    data.append("card[name]", this.messages),

    Rails.ajax({
      url: "/cards",
      type: "POST",
      data: data,
      dataType: "json",
      success: (data) => {
        const index = window.store.lists.findIndex(item => item.id == list_id);
        window.store.lists[index].cards.push(data);
        this.message = "";
        } 
      });
    }
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 20px;
},

  .list {
  background: #E2E4E6;
  border-radius: 5px;
  display: inline-block;
  margin-right: 20px;  
  padding: 10px; 
  vertical-align: top;
  width: 270px;

}
</style>