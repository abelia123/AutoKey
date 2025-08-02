import sys
import math
import os
os.environ['QT_ENABLE_HIGHDPI_SCALING'] = '0'
from PyQt6.QtWidgets import QApplication, QWidget
from PyQt6.QtCore import Qt, QPoint, QPointF, QTimer, pyqtSignal
from PyQt6.QtGui import QPainter, QColor, QFont, QRadialGradient, QPen, QBrush
from pynput import mouse
import pyautogui

class DirectionOverlay(QWidget):
    def __init__(self):
        super().__init__()
        self.current_direction = ""
        self.start_pos = None
        self.threshold = 30
        self.animation_value = 0
        self.pulse_animation = 0
        
        # UI設定（8方向対応で少し大きく）
        self.setWindowFlags(Qt.WindowType.FramelessWindowHint | 
                          Qt.WindowType.WindowStaysOnTopHint | 
                          Qt.WindowType.Tool)
        self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
        self.setFixedSize(400, 400)
        
        # アニメーションタイマー
        self.animation_timer = QTimer()
        self.animation_timer.timeout.connect(self.update_animations)
        self.animation_timer.start(16)  # 60 FPS
        
        # 8方向定義（論理的な配置に再構成）
        center_x, center_y = 200, 200
        radius = 120
        
        self.directions = {
            # 上部：テキスト入力系
            "up": {
                "text": "Select All", 
                "symbol": "🎯", 
                "pos": (center_x, center_y - radius), 
                "color": QColor(100, 200, 255),  # シアン
                "action": lambda: pyautogui.hotkey('ctrl', 'a')
            },
            # 右上：コピー（右下のペーストと対）
            "up_right": {
                "text": "Copy", 
                "symbol": "📋", 
                "pos": (center_x + int(radius * 0.707), center_y - int(radius * 0.707)), 
                "color": QColor(255, 200, 100),  # オレンジ
                "action": lambda: pyautogui.hotkey('ctrl', 'c')
            },
            # 右：保存
            "right": {
                "text": "Save", 
                "symbol": "💾", 
                "pos": (center_x + radius, center_y), 
                "color": QColor(60, 179, 113),  # MediumSeaGreen
                "action": lambda: pyautogui.hotkey('ctrl', 's')
            },
            # 右下：ペースト（右上のコピーと対）
            "down_right": {
                "text": "Paste", 
                "symbol": "📏", 
                "pos": (center_x + int(radius * 0.707), center_y + int(radius * 0.707)), 
                "color": QColor(100, 255, 150),  # ミントグリーン
                "action": lambda: pyautogui.hotkey('ctrl', 'v')
            },
            # 下：Enter（確定）
            "down": {
                "text": "Enter", 
                "symbol": "⏎", 
                "pos": (center_x, center_y + radius), 
                "color": QColor(75, 0, 130),  # Indigo
                "action": lambda: pyautogui.press('enter')
            },
            # 左下：スクリーンショット
            "down_left": {
                "text": "Screenshot", 
                "symbol": "📷", 
                "pos": (center_x - int(radius * 0.707), center_y + int(radius * 0.707)), 
                "color": QColor(220, 20, 60),  # Crimson
                "action": lambda: pyautogui.hotkey('win', 'shift', 's')
            },
            # 左：Undo（戻る系操作）
            "left": {
                "text": "Undo", 
                "symbol": "↶", 
                "pos": (center_x - radius, center_y), 
                "color": QColor(255, 165, 0),  # Orange
                "action": lambda: pyautogui.hotkey('ctrl', 'z')
            },
            # 左上：Backspace（削除）
            "up_left": {
                "text": "Backspace", 
                "symbol": "⌫", 
                "pos": (center_x - int(radius * 0.707), center_y - int(radius * 0.707)), 
                "color": QColor(178, 34, 34),  # FireBrick
                "action": lambda: pyautogui.press('backspace')
            }
        }
        
    def show_at_mouse(self):
        cursor_pos = QPoint(*pyautogui.position())
        self.move(cursor_pos.x() - 200, cursor_pos.y() - 200)
        self.animation_value = 0
        self.show()
        
    def hide_overlay(self):
        self.hide()
        self.current_direction = ""
        self.pulse_animation = 0
        
    def execute_action(self):
        if self.current_direction and self.current_direction in self.directions:
            self.directions[self.current_direction]["action"]()
            
    def update_direction(self, direction):
        if direction != self.current_direction:
            self.current_direction = direction
            self.update()
            
    def update_animations(self):
        if self.isVisible() and self.animation_value < 1:
            self.animation_value = min(1, self.animation_value + 0.08)
            self.update()
            
        if self.current_direction:
            self.pulse_animation = (self.pulse_animation + 0.1) % (2 * math.pi)
            self.update()
            
    def paintEvent(self, event):
        painter = QPainter(self)
        painter.setRenderHint(QPainter.RenderHint.Antialiasing)
        
        opacity = self.animation_value
        center = QPointF(200, 200)
        
        # 背景（黒ベースに戻す）
        bg_gradient = QRadialGradient(center, 140)
        bg_gradient.setColorAt(0, QColor(25, 25, 35, int(200 * opacity)))
        bg_gradient.setColorAt(0.8, QColor(15, 15, 25, int(220 * opacity)))
        bg_gradient.setColorAt(1, QColor(10, 10, 20, int(180 * opacity)))
        painter.setBrush(QBrush(bg_gradient))
        painter.setPen(Qt.PenStyle.NoPen)
        painter.drawEllipse(center, 140, 140)
        
        # リング
        painter.setPen(QPen(QColor(100, 100, 120, int(100 * opacity)), 2))
        painter.setBrush(Qt.BrushStyle.NoBrush)
        painter.drawEllipse(center, 138, 138)
        
        # 内側の装飾リング
        painter.setPen(QPen(QColor(80, 80, 100, int(50 * opacity)), 1))
        painter.drawEllipse(center, 95, 95)
        
        # 8方向インジケーター
        for direction, info in self.directions.items():
            x, y = info["pos"]
            is_selected = direction == self.current_direction
            
            # ボタンサイズ（全て統一）
            button_size = 28
            
            if is_selected:
                pulse_size = button_size + int(3 * math.sin(self.pulse_animation))
                
                # グロー効果
                glow = QRadialGradient(QPointF(x, y), pulse_size + 15)
                color = info["color"]
                glow.setColorAt(0, QColor(color.red(), color.green(), color.blue(), int(80 * opacity)))
                glow.setColorAt(0.4, QColor(color.red(), color.green(), color.blue(), int(40 * opacity)))
                glow.setColorAt(1, QColor(color.red(), color.green(), color.blue(), 0))
                painter.setBrush(QBrush(glow))
                painter.setPen(Qt.PenStyle.NoPen)
                painter.drawEllipse(QPointF(x, y), pulse_size + 15, pulse_size + 15)
                
                # メインサークル
                circle_gradient = QRadialGradient(QPointF(x, y), button_size)
                circle_gradient.setColorAt(0, QColor(255, 255, 255, int(50 * opacity)))
                circle_gradient.setColorAt(0.3, info["color"])
                circle_gradient.setColorAt(1, QColor(color.red() // 2, color.green() // 2, color.blue() // 2, int(255 * opacity)))
                painter.setBrush(QBrush(circle_gradient))
                painter.setPen(QPen(info["color"], 2))
                painter.drawEllipse(QPointF(x, y), button_size, button_size)
                
                # アイコン
                font = QFont("Segoe UI Emoji", 20, QFont.Weight.Bold)
                painter.setFont(font)
                painter.setPen(QColor(255, 255, 255))
                symbol_rect = painter.boundingRect(x - button_size, y - button_size, button_size * 2, button_size * 2, 
                                                 Qt.AlignmentFlag.AlignCenter, info["symbol"])
                painter.drawText(symbol_rect, Qt.AlignmentFlag.AlignCenter, info["symbol"])
                
            else:
                # 非選択時
                painter.setBrush(QColor(40, 40, 50, int(120 * opacity)))
                painter.setPen(QPen(QColor(70, 70, 80, int(150 * opacity)), 1))
                painter.drawEllipse(QPointF(x, y), button_size, button_size)
                
                # アイコン
                font = QFont("Segoe UI Emoji", 16)
                painter.setFont(font)
                painter.setPen(QColor(120, 120, 140, int(180 * opacity)))
                arrow_rect = painter.boundingRect(x - button_size, y - button_size, button_size * 2, button_size * 2,
                                                Qt.AlignmentFlag.AlignCenter, info["symbol"])
                painter.drawText(arrow_rect, Qt.AlignmentFlag.AlignCenter, info["symbol"])
            
            # テキスト位置（ボタンの外側）を先に計算
            text_radius = 165
            angle = math.atan2(y - 200, x - 200)
            text_x = int(200 + text_radius * math.cos(angle))
            text_y = int(200 + text_radius * math.sin(angle))
            
            text_rect = painter.boundingRect(text_x - 40, text_y - 10, 80, 20,
                                           Qt.AlignmentFlag.AlignCenter, info["text"])
            
            # テキストを外側に配置（白背景対応）
            font = QFont("Segoe UI", 11, QFont.Weight.Bold)
            painter.setFont(font)
            if is_selected:
                painter.setPen(QColor(255, 255, 255, int(255 * opacity)))
            else:
                painter.setPen(QColor(180, 180, 200, int(200 * opacity)))
            painter.drawText(text_rect, Qt.AlignmentFlag.AlignCenter, info["text"])

class MouseHandler:
    def __init__(self, overlay):
        self.overlay = overlay
        self.mouse_listener = None
        self.tracking = False
        self.start_x = 0
        self.start_y = 0
        
    def start(self):
        self.mouse_listener = mouse.Listener(
            on_click=self.on_click,
            on_move=self.on_move
        )
        self.mouse_listener.start()
        
    def on_click(self, x, y, button, pressed):
        if button == mouse.Button.x2:
            if pressed:
                self.tracking = True
                self.start_x, self.start_y = x, y
                self.overlay.show_at_mouse()
            else:
                if self.tracking and self.overlay.current_direction:
                    self.overlay.execute_action()
                self.overlay.hide_overlay()
                self.tracking = False
                    
    def on_move(self, x, y):
        if self.tracking:
            dx = x - self.start_x
            dy = y - self.start_y
            
            distance = math.sqrt(dx**2 + dy**2)
            if distance > self.overlay.threshold:
                # 8方向判定
                angle = math.atan2(dy, dx)
                # -π～πを0～2πに変換
                if angle < 0:
                    angle += 2 * math.pi
                
                # 45度ごとの8方向に分割
                sector = int((angle + math.pi/8) / (math.pi/4)) % 8
                directions = ["right", "down_right", "down", "down_left", 
                            "left", "up_left", "up", "up_right"]
                
                self.overlay.update_direction(directions[sector])
            else:
                self.overlay.update_direction("")

def main():
    app = QApplication(sys.argv)
    
    overlay = DirectionOverlay()
    handler = MouseHandler(overlay)
    handler.start()
    
    sys.exit(app.exec())

if __name__ == "__main__":
    main()