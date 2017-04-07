function Position() {
    this.left = 0;
    this.top = 0;
    this.height = 0;
    this.width = 0;
}

function GetPosition(srcElement, location) {
    location.left = 0;
    location.top = 0;
    location.height = srcElement.offsetHeight;
    location.width = srcElement.offsetWidth;

    while (srcElement) {
        location.left += srcElement.offsetLeft;
        location.top += srcElement.offsetTop;
        srcElement = srcElement.offsetParent;
    }
}


