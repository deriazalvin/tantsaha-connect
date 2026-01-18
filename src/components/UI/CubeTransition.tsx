import React from "react";
import { motion } from "framer-motion";

type Direction = "left" | "right";

export default function CubeTransition({
    direction = "left",
    duration = 0.95,
    children,
}: {
    direction?: Direction;
    duration?: number;
    children: React.ReactNode;
}) {
    const left = direction === "left";

    const enter = {
        rotateY: left ? 85 : -85,
        x: left ? "18%" : "-18%",
        opacity: 0,
        scale: 0.985,
        filter: "blur(1.5px)",
        transformOrigin: left ? "left center" : "right center",
        // petit “depth” pour l’effet cube
        translateZ: -80,
    };

    const center = {
        rotateY: 0,
        x: "0%",
        opacity: 1,
        scale: 1,
        filter: "blur(0px)",
        transformOrigin: "center center",
        translateZ: 0,
    };

    const leave = {
        rotateY: left ? -85 : 85,
        x: left ? "-18%" : "18%",
        opacity: 0,
        scale: 0.985,
        filter: "blur(1.5px)",
        transformOrigin: left ? "right center" : "left center",
        translateZ: -80,
    };

    return (
        <div
            className="min-h-screen w-full overflow-hidden"
            style={{
                perspective: 1800,
                perspectiveOrigin: "50% 45%",
                background: "transparent",
            }}
        >
            <motion.div
                style={{
                    transformStyle: "preserve-3d",
                    willChange: "transform",
                }}
                initial={enter}
                animate={center}
                exit={leave}
                transition={{
                    duration,
                    ease: [0.16, 1, 0.3, 1], // très smooth (easeOutExpo-ish)
                }}
            >
                {/* Ombre pendant l’animation (donne du “poids”) */}
                <motion.div
                    aria-hidden
                    className="pointer-events-none fixed inset-0"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 0.08 }}
                    exit={{ opacity: 0 }}
                    transition={{ duration: duration * 0.7, ease: [0.16, 1, 0.3, 1] }}
                    style={{ background: "black" }}
                />
                <div style={{ position: "relative" }}>{children}</div>
            </motion.div>
        </div>
    );
}
