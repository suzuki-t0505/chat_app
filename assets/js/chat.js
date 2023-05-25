let hooks = {}

hooks.key = {
  mounted(){
    let input = document.getElementById("message-input")
    input.addEventListener("keypress", e => {
      if (e.key == "Enter") {
        if (e.ctrlKey) {
          this.pushEvent("send_message", {message: {message: e.target.value}})
          e.target.value = ""
        } else {
          e.preventDefault()
          return false;
        }
      }
    }, false)
  }
}

hooks.scroll = {
  mounted(){
    scrollToTheBottom()
  },
  updated(){
    scrollToTheBottom()
  }
}

function scrollToTheBottom(){
  let target = document.getElementById("scroll-box").lastElementChild
  if (target) {
    target.scrollIntoView(false)
  }
}

export default hooks